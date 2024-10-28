import 'package:trellotech/models/trello_list.dart';

class TrelloBoard {
  String id;
  String name;
  List<TrelloList> lists = [];

  TrelloBoard({
    required this.id,
    required this.name,
    required this.lists,
  });

  factory TrelloBoard.fromJson(Map<String, dynamic> json) {
    List<TrelloList> lists = (json['lists'] as List<dynamic>)
        .map((list) => TrelloList.fromJson(list))
        .toList();

    return TrelloBoard(
      id: json['id'],
      name: json['name'],
      lists: lists,
    );
  }
}
