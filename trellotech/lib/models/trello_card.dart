import 'package:trellotech/models/trello_members.dart';

class TrelloCard {
  final String id;
  final String name;
  final String description;
  final String listId;
  final String boardId;
  late List<TrelloMembers> members = [];

  TrelloCard({
    required this.id,
    required this.name,
    required this.description,
    required this.listId,
    required this.boardId,
    required this.members,
  });

  factory TrelloCard.fromJson(Map<String, dynamic> json) {
    List<dynamic> idMembers = json['idMembers'];

    List<TrelloMembers> members = idMembers
        .map((id) => TrelloMembers(id: id, fullName: '', username: ''))
        .toList();

    return TrelloCard(
      id: json['id'],
      name: json['name'],
      description: json['desc'],
      listId: json['idList'],
      boardId: json['idBoard'],
      members: members,
    );
  }
}
