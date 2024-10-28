import 'package:trellotech/models/trello_card.dart';

class TrelloList {
  String id;
  String name;
  List<TrelloCard> cards;

  TrelloList({
    required this.id,
    required this.name,
    required this.cards,
  });

  factory TrelloList.fromJson(Map<String, dynamic> json) {
    List<TrelloCard> cards = (json['cards'] as List<dynamic>)
        .map((card) => TrelloCard.fromJson(card))
        .toList();

    return TrelloList(
      id: json['id'],
      name: json['name'],
      cards: cards,
    );
  }
}
