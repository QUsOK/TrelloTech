import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:trellotech/models/trello_token.dart';
import 'package:trellotech/screens/organization_screen.dart';
import 'package:trellotech/models/trello_organization.dart';
import 'package:trellotech/services/trello_service_organisation.dart';

class HomePage extends StatefulWidget {
  final TrelloToken token;

  const HomePage({super.key, required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  // bouton avec la modale pour créer une organization
  Future<void> _showCreateOrganizationDialog(BuildContext context) async {
    String organizationName = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer une nouvelle organisation'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration:
                  const InputDecoration(hintText: 'Nom de l\'organisation'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer un nom pour l\'organisation';
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
                    await TrelloServiceOrganisation(widget.token)
                        .createOrganization(organizationName);
                    // Ajoutez ici la logique pour mettre à jour la liste des organisations
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrelloTech',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 206, 203, 243),
      ),
      home: Scaffold(
        // Définissez la couleur de fond ici

        appBar: AppBar(title: const Text('TrelloTech')),
        body: Stack(
          children: [
            const ModelViewer(
              src: "assets/trio_cat.glb",
              autoRotate: true,
              autoPlay: false,
              rotationPerSecond: '999.9',
            ),
            FutureBuilder<List<TrelloOrg>>(
              future:
                  TrelloServiceOrganisation(widget.token).getOrganizations(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final organization = snapshot.data![index];
                      return ListTile(
                        title: Text(organization.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                String newName = '';

                                // Affichez un dialogue pour modifier le nom de l'organisation
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Modifier le nom de l\'organisation'),
                                      content: TextField(
                                        onChanged: (value) {
                                          newName = value;
                                        },
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Annuler'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Enregistrer'),
                                          onPressed: () {
                                            Navigator.of(context).pop();

                                            // Mettez à jour l'organisation avec le nouveau nom
                                            final updatedOrganization =
                                                TrelloOrg(
                                              id: organization.id,
                                              name: newName,
                                              boards: organization.boards,
                                            );
                                            final trelloService =
                                                TrelloServiceOrganisation(
                                                    widget.token);
                                            trelloService.updateOrganization(
                                                updatedOrganization);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(
                                width:
                                    5), // penser à changer la taille des icons
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                try {
                                  final trelloService =
                                      TrelloServiceOrganisation(widget.token);
                                  await trelloService
                                      .deleteOrganization(organization.id);

                                  // Rafraîchissez la liste des organisations ou supprimez l'organisation de la liste affichée
                                  // ignore: empty_catches
                                } catch (e) {}
                              },
                            ),
                            const SizedBox(
                                width:
                                    5), // Ajoutez un peu d'espace entre les boutons
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrgScreen(
                                      organization.id,
                                      widget.token,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Voir'),
                            ),
                          ],
                        ),
                      );
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
            _showCreateOrganizationDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
