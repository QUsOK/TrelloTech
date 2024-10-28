import 'package:flutter/material.dart';
import 'package:trellotech/models/trello_list.dart'; // Assurez-vous d'importer votre modèle TrelloList ici
import 'package:trellotech/models/trello_members.dart';
import 'package:trellotech/widgets/card_widget.dart';

class ListWidget extends StatelessWidget {
  final TrelloList lists;
  final List<TrelloMembers> memberBoard;
  final Function(String) onAddCard;
  final Function(String) onUpdateCard;
  final Function(String, String) onUpdateMemberCard;
  final Function(String) onDeleteCard;
  final Function(String) onDeleteList;
  final Function(String, String) onUpdateList;

  const ListWidget({
    super.key,
    required this.lists,
    required this.memberBoard,
    required this.onAddCard,
    required this.onUpdateCard,
    required this.onUpdateMemberCard,
    required this.onDeleteCard,
    required this.onDeleteList,
    required this.onUpdateList,
  });

  @override
  Widget build(BuildContext context) {
    var list = lists;
    final TextEditingController controller =
        TextEditingController(text: list.name);
    return Column(
      children: [
        Text(list.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Column(
          children: list.cards
              .map((card) => CardWidget(
                  card: card,
                  onUpdateMemberCard: onUpdateMemberCard,
                  memberBoard: memberBoard,
                  onUpdateCard: onUpdateCard,
                  onDeleteCard: onDeleteCard))
              .toList(), // Passez les fonctions de rappel ici
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Modifier le nom de la liste'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Entrez le nouveau nom de la liste',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('ANNULER'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('ENREGISTRER'),
                          onPressed: () {
                            final newListName = controller.text;
                            if (newListName.isNotEmpty) {
                              onUpdateList(list.id,
                                  newListName); // Appelez la fonction onUpdateList ici
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                onDeleteList(list.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Ajoutez la logique pour créer une nouvelle carte dans cette liste
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newCardTitle = '';
                    return AlertDialog(
                      title: const Text('Ajouter une nouvelle carte'),
                      content: TextField(
                        onChanged: (value) {
                          newCardTitle = value;
                        },
                        decoration: const InputDecoration(
                            hintText: "Entrez le titre de la carte"),
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
                            if (newCardTitle.isNotEmpty) {
                              onAddCard(
                                  newCardTitle); // Appelez la fonction onAddCard ici
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
