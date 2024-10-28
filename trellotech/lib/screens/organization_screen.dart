import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:trellotech/models/trello_board.dart';
import 'package:trellotech/models/trello_token.dart';
import 'package:trellotech/screens/board_screen.dart';
import 'package:trellotech/services/trello_service_board.dart';
import 'package:trellotech/services/trello_service_organisation.dart';

class OrgScreen extends StatefulWidget {
  final String organizationId;
  final TrelloToken token;
  const OrgScreen(this.organizationId, this.token, {super.key});

  @override
  _OrgScreenState createState() => _OrgScreenState();
}

class _OrgScreenState extends State<OrgScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _showCreateBoardDialog(BuildContext context) async {
    String organizationName = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un nouveau tableau'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(hintText: 'Nom du tableau'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer un nom pour le tableau';
                }
                return null;
              },
              onSaved: (value) {
                organizationName = value!;
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  try {
                    await TrelloServiceBoard(widget.token)
                        .createBoard(organizationName, widget.organizationId);
                    // ignore: empty_catches
                  } catch (e) {}
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(TrelloBoard board) async {
    final nameController = TextEditingController(text: board.name);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier le tableau'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom du tableau'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final updatedBoard = TrelloBoard(
                  id: board.id,
                  name: nameController.text,
                  lists: [],
                );
                await TrelloServiceBoard(widget.token)
                    .updateBoard(updatedBoard);

                Navigator.of(context).pop();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _onDeletePressed(TrelloBoard board) async {
    // Afficher une modale de confirmation avant de supprimer le tableau
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer le tableau'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer ce tableau ?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    // Si l'utilisateur confirme la suppression, appeler la méthode deleteBoard
    if (confirmDelete == true) {
      try {
        await TrelloServiceBoard(widget.token).deleteBoard(board.id);
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    String orgId = widget.organizationId;
    return MaterialApp(
      title: 'TrelloTech',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TrelloTech - Boards '),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
          children: [
            const ModelViewer(
              backgroundColor: Color.fromARGB(255, 206, 203, 243),
              src: "assets/rick_morty.glb",
            ),
            FutureBuilder<List<TrelloBoard>>(
              future: TrelloServiceOrganisation(widget.token)
                  .getBoardsForOrganization(
                      orgId), // Passer organizationId comme argument
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final board = snapshot.data![index];
                      return ListTile(
                          title: Text(board.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditDialog(board);
                                },
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _onDeletePressed(board);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BoardScreen(
                                        boardId: board.id,
                                        token: widget.token,
                                      )),
                            );
                          });
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreateBoardDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
