import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:trellotech/models/trello_members.dart';
import 'package:trellotech/models/trello_token.dart';
import 'package:trellotech/services/trello_service_board.dart';
import 'package:trellotech/widgets/list_widget.dart';
import 'package:trellotech/models/trello_list.dart';
import 'package:trellotech/services/trello_service_list.dart';

class BoardScreen extends StatefulWidget {
  final String boardId;
  final TrelloToken token;
  const BoardScreen({super.key, required this.boardId, required this.token});

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  List<TrelloList> _lists = [];
  List<TrelloMembers> _membersBoard = [];

  @override
  void initState() {
    super.initState();
    _loadMembersBoard();
    _loadListsAndCards();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadMembersBoard() async {
    List<TrelloMembers> membersBoard =
        await TrelloServiceBoard(widget.token).getMembersBoard(widget.boardId);
    setState(() {
      _membersBoard = membersBoard;
    });
  }

  Future<void> _loadListsAndCards() async {
    List<TrelloList> lists = await TrelloServiceList(widget.token)
        .getAllListsAndCards(widget.boardId);
    setState(() {
      _lists = lists;
    });
  }

  Future<void> _addNewList(String listTitle) async {
    TrelloList newList = TrelloList(id: '', name: listTitle, cards: []);

    // Assuming createList method expects a String (list name)
    await TrelloServiceList(widget.token)
        .createList(widget.boardId, newList.name);

    setState(() {
      _lists.add(newList);
    });
  }

  Future<void> _addNewCard(String cardTitle, String listId) async {
    await TrelloServiceList(widget.token).createCard(listId, cardTitle);

    // Recharger les listes et les cartes pour mettre à jour l'interface utilisateur
    _loadListsAndCards();
  }

// methode qui créer une modal pour ajouter une list
  Future<void> _showAddListDialog(BuildContext context) async {
    String newListTitle = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter une nouvelle list'),
          content: TextField(
            onChanged: (value) {
              newListTitle = value;
            },
            decoration:
                const InputDecoration(hintText: "écrit la nouvelle liste"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANNULER'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('AJOUTER'),
              onPressed: () {
                if (newListTitle.isNotEmpty) {
                  _addNewList(newListTitle);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateCard(String listId, String cardId) async {
    // Obtenir les nouvelles informations de la carte à partir de l'utilisateur
    String newCardName = '';
    String newCardDescription = '';

    // Afficher une boîte de dialogue pour obtenir les nouvelles informations de la carte
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mettre à jour la carte'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newCardName = value;
                },
                decoration: const InputDecoration(
                    hintText: "Entrez le nouveau nom de la carte"),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  newCardDescription = value;
                },
                decoration: const InputDecoration(
                    hintText: "Entrez la nouvelle description de la carte"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('ANNULER'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('METTRE À JOUR'),
              onPressed: () async {
                await TrelloServiceList(widget.token).updateCard(
                    listId, cardId, newCardName, newCardDescription);

                _loadListsAndCards();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCard(String cardId) async {
    // Implémentez la logique pour supprimer la carte ici
    await TrelloServiceList(widget.token).deleteCard(cardId);

    // Recharger les listes et les cartes pour mettre à jour l'interface utilisateur
    _loadListsAndCards();
  }

  Future<void> _deleteList(String listId) async {
    await TrelloServiceList(widget.token).deleteList(listId);
    _loadListsAndCards();
  }

  Future<void> _updateList(String listId, String listName) async {
    await TrelloServiceList(widget.token).updateList(listId, listName);

    // Recharger les listes et les cartes pour mettre à jour l'interface utilisateur
    _loadListsAndCards();
  }

  Future<void> _onUpdateMemberCard(String cardId, String memberId) async {
    await TrelloServiceList(widget.token).onUpdateMemberCard(cardId, memberId);

    // Recharger les listes et les cartes pour mettre à jour l'interface utilisateur
    _loadListsAndCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Boards'),
      ),
      body: Stack(
        children: [
          const ModelViewer(
            backgroundColor: Color.fromARGB(255, 206, 203, 243),
            src: "assets/osaka.glb",
            alt: "A 3D model",
          ),
          Positioned(
            child: Column(
              children: [
                // List de membres avec 20% de l'écran
                Expanded(
                  flex: 2, // 20% de l'écran
                  child: _buildMembersList(),
                ),
                // List de cartes avec 80% de l'écran
                Expanded(
                  flex: 8, // 80% de l'écran
                  child: _buildCardList(),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddListDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMembersList() {
    return GridView.count(
      crossAxisCount: 3, // Nombre de colonnes dans le tableau
      childAspectRatio: 3,
      padding: const EdgeInsets.all(8), // Ajouter un padding autour du tableau
      children: _membersBoard.map((member) {
        return Container(
          padding:
              const EdgeInsets.all(8), // Ajouter un padding à chaque élément
          decoration: BoxDecoration(
            color: const Color.fromARGB(162, 0, 0, 0), // Couleur de fond noire
            border: Border.all(color: Colors.white), // Bordure blanche
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.fullName,
                style: const TextStyle(
                    color: Colors.white, fontSize: 10), // Texte en blanc
              ),
              Text(
                member.username,
                style: const TextStyle(
                    color: Colors.white, fontSize: 8), // Texte en blanc
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCardList() {
    if (_lists.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: _lists.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListWidget(_lists[index], _membersBoard);
        },
      );
    }
  }

  Widget _buildListWidget(TrelloList list, List<TrelloMembers> _membersBoard) {
    return ListWidget(
      lists: list,
      memberBoard: _membersBoard,
      onAddCard: (cardTitle) {
        _addNewCard(cardTitle, list.id);
      },
      onUpdateCard: (cardId) {
        _updateCard(list.id, cardId);
      },
      onUpdateMemberCard: (cardId, memberId) {
        _onUpdateMemberCard(cardId, memberId);
      },
      onDeleteCard: (cardId) {
        _deleteCard(cardId);
      },
      onDeleteList: (listId) {
        _deleteList(listId);
      },
      onUpdateList: (listId, listName) {
        _updateList(listId, listName);
      },
    );
  }
}
