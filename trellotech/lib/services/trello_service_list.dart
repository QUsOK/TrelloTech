import 'package:http/http.dart' as http;
import 'package:trellotech/env.dart';
import 'package:trellotech/models/trello_members.dart';
import 'dart:convert';
import 'package:trellotech/models/trello_token.dart';
import '../models/trello_card.dart';
import '../models/trello_list.dart';

class TrelloServiceList {
  late TrelloToken token;
  TrelloServiceList(this.token);

  Future<List<TrelloCard>> getCards(String boardId) async {
    Uri url = Uri.parse(
        'https://api.trello.com/1/boards/$boardId/cards?key=${Env.apikey}&token=${token.token}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<TrelloCard> cards = data.map((cardData) {
        return TrelloCard.fromJson(cardData);
      }).toList();
      return cards;
    } else {
      throw Exception('Failed to load cards');
    }
  }

  Future<List<TrelloList>> getAllListsAndCards(String boardId) async {
    Uri url = Uri.parse(
        'https://api.trello.com/1/boards/$boardId/lists?key=${Env.apikey}&token=${token.token}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<TrelloList> lists = [];
      for (var listData in responseData) {
        String listId = listData['id'];

        // Récupérer les cartes associées à la liste
        List<TrelloCard> cards = await _getCardsForList(listId);

        // Créer un objet TrelloList avec les cartes récupérées
        TrelloList list = TrelloList(
          id: listId,
          name: listData['name'],
          cards: cards,
        );
        lists.add(list);
      }
      return lists;
    } else {
      throw Exception('Failed to load lists and cards');
    }
  }

  Future<List<TrelloCard>> _getCardsForList(String listId) async {
    Uri url = Uri.parse(
        'https://api.trello.com/1/lists/$listId/cards?key=${Env.apikey}&token=${token.token}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<TrelloCard> cards = responseData
          .map((cardData) => TrelloCard.fromJson(cardData))
          .toList();
      for (var card in cards) {
        if (card.members.isNotEmpty) {
          card.members = await getInfoMembers(card.id);
        }
      }
      return cards;
    } else {
      throw Exception('Failed to load cards for list');
    }
  }

  Future<TrelloList> createList(String boardId, String listName) async {
    Uri url = Uri.parse(
        'https://api.trello.com/1/boards/$boardId/lists?name=$listName&pos=top&key=${Env.apikey}&token=${token.token}');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final TrelloList newList = TrelloList(
          id: jsonResponse['id'], name: jsonResponse['name'], cards: []);
      return newList;
    } else {
      throw Exception('Failed to create Trello list');
    }
  }

  Future<void> deleteList(String listId) async {
    final String url =
        'https://api.trello.com/1/lists/$listId/closed?value=true&key=${Env.apikey}&token=${token.token}';
    final http.Response response = await http.put(Uri.parse(url));

    if (response.statusCode == 200) {
      // La liste a été supprimée avec succès
    } else {
      throw Exception('Échec de la suppression de la liste');
    }
  }

  Future<void> updateList(String listId, String listName) async {
    final String url =
        'https://api.trello.com/1/lists/$listId/?name=$listName&key=${Env.apikey}&token=${token.token}';
    final http.Response response = await http.put(Uri.parse(url));

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to create Trello list');
    }
  }

  Future<void> createCard(String listId, String cardTitle) async {
    final String url =
        'https://api.trello.com/1/cards?idList=$listId&name=$cardTitle&key=${Env.apikey}&token=${token.token}';

    final http.Response response = await http.post(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to create card');
    }
  }

  Future<void> updateCard(String listId, String cardId, String newCardName,
      String newCardDescription) async {
    late String url;
    if (newCardName.isEmpty) {
      url =
          'https://api.trello.com/1/cards/$cardId?desc=$newCardDescription&key=${Env.apikey}&token=${token.token}';
    } else if (newCardDescription.isEmpty) {
      url =
          'https://api.trello.com/1/cards/$cardId?name=$newCardName&key=${Env.apikey}&token=${token.token}';
    } else {
      url =
          'https://api.trello.com/1/cards/$cardId?name=$newCardName&desc=$newCardDescription&key=${Env.apikey}&token=${token.token}';
    }

    final http.Response response = await http.put(Uri.parse(url));

    if (response.statusCode == 200) {
      // La carte a été mise à jour avec succès
    } else {
      throw Exception('Échec de la mise à jour de la carte');
    }
  }

  Future<void> deleteCard(String cardId) async {
    final String url =
        'https://api.trello.com/1/cards/$cardId?key=${Env.apikey}&token=${token.token}';

    final http.Response response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      // La carte a été mise à jour avec succès
    } else {
      throw Exception('Échec de la mise à jour de la carte');
    }
  }

  Future<List<TrelloMembers>> getInfoMembers(String cardId) async {
    Uri url = Uri.parse(
        'https://api.trello.com/1/cards/$cardId/members?key=${Env.apikey}&token=${token.token}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<TrelloMembers> members = [];
      for (var memberData in data) {
        TrelloMembers member = TrelloMembers(
          id: memberData['id'],
          username: memberData['username'],
          fullName: memberData['fullName'],
        );
        members.add(member);
      }
      return members;
    } else {
      throw Exception('Failed to load members');
    }
  }

  Future<void> onUpdateMemberCard(String cardId, String memberId) async {
    Uri url = Uri.parse(
        'https://api.trello.com/1/cards/$cardId/idMembers?value=$memberId&key=${Env.apikey}&token=${token.token}');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      // La carte a été mise à jour avec succès
    } else {
      throw Exception('Échec de la mise à jour de la carte');
    }
  }
}
