import 'package:trellotech/models/trello_board.dart';

class TrelloOrg {
  final String id;
  final String name;
  final List<TrelloBoard> boards;

  TrelloOrg({
    required this.id,
    required this.name,
    required this.boards,
  });

  factory TrelloOrg.fromJson(Map<String, dynamic> json) {
    List<TrelloBoard> cards = (json['cards'] as List<dynamic>)
        .map((card) => TrelloBoard.fromJson(card))
        .toList();

    return TrelloOrg(
      id: json['id'],
      name: json['name'],
      boards: cards,
    );
  }
}
