import 'package:flutter/material.dart';
import 'package:trellotech/models/trello_card.dart';
import 'package:trellotech/models/trello_members.dart';

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  final TrelloCard card;
  late List<TrelloMembers> memberBoard = [];
  final Function(String) onUpdateCard;
  final Function(String, String) onUpdateMemberCard;
  final Function(String) onDeleteCard;

  CardWidget(
      {super.key,
      required this.card,
      required this.memberBoard,
      required this.onUpdateCard,
      required this.onUpdateMemberCard,
      required this.onDeleteCard});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(card.name),
        subtitle: Text(card.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                onUpdateCard(card.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                onDeleteCard(card.id);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardDetailScreen(
                  card: card,
                  memberBoard: memberBoard,
                  onUpdateMemberCard: onUpdateMemberCard),
            ),
          );
        },
      ),
    );
  }
}

class CardDetailScreen extends StatelessWidget {
  final TrelloCard card;
  final List<TrelloMembers> memberBoard;
  final Function(String, String) onUpdateMemberCard;

  const CardDetailScreen(
      {super.key,
      required this.card,
      required this.memberBoard,
      required this.onUpdateMemberCard});

  void addMemberToCard(BuildContext context, String selectedMember) {
    if (selectedMember.isNotEmpty) {
      // Ajoutez le membre à la carte
      onUpdateMemberCard(card.id, selectedMember);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un membre.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedMember = '';
    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(card.description),
            const SizedBox(height: 16),
            const Text(
              'Membres assignés:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: card.members
                  .map((member) => ListTile(
                        title: Text(member.fullName),
                      ))
                  .toList(),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Ajouter un membre'),
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return DropdownButton<String>(
                            hint: const Text('Sélectionnez un membre'),
                            value: selectedMember,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedMember = newValue!;
                              });
                            },
                            items: [
                              // Ajoutez un élément par défaut avec une valeur nulle ou vide
                              const DropdownMenuItem<String>(
                                value: "",
                                child: Text('Sélectionnez un membre'),
                              ),
                              // Ajoutez les membres de la liste avec leur nom et leur ID
                              ...memberBoard.map(
                                (member) => DropdownMenuItem<String>(
                                  value: member.id,
                                  child: Text(member.fullName),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            addMemberToCard(context, selectedMember);
                          },
                          child: const Text('Ajouter'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annuler'),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
