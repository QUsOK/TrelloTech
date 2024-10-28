import 'package:http/http.dart' as http;
import 'package:trellotech/env.dart';
import 'package:trellotech/models/trello_board.dart';
import 'package:trellotech/models/trello_members.dart';
import 'dart:convert';

import 'package:trellotech/models/trello_token.dart';

class TrelloServiceBoard {
  late TrelloToken token;
  TrelloServiceBoard(this.token);

  Future<TrelloBoard> createBoard(String displayName, String idOrg) async {
    final url =
        Uri.parse('https://api.trello.com/1/boards').replace(queryParameters: {
      'idOrganization': idOrg,
      'displayName': displayName,
      'desc': 'descriptiondelespace',
      'defaultLabels': 'true',
      'defaultLists': 'true',
      'name': displayName,
      'website': 'epitech.eu',
      'key': Env.apikey,
      'token': token.token,
    });

    final response = await http.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return TrelloBoard.fromJson(data);
    } else {
      throw Exception('Echec | Création de l\'organisation impossible.');
    }
  }

  Future<void> updateBoard(TrelloBoard board) async {
    final url = Uri.parse(
        'https://api.trello.com/1/boards/${board.id}?key=${Env.apikey}&token=${token.token}');
    final response = await http.put(url, body: {
      'name': board.name,
      'lists': 'je suis la',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to update board');
    }
  }

  Future<void> deleteBoard(String boardId) async {
    final url = Uri.parse(
        'https://api.trello.com/1/boards/$boardId?key=${Env.apikey}&token=${token.token}');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Echec | suppression du tableau impossible.');
    }
  }

  Future<List<TrelloMembers>> getMembersBoard(String boardId) async {
    final String url =
        'https://api.trello.com/1/boards/$boardId/members?key=${Env.apikey}&token=${token.token}';
    final http.Response response = await http.get(Uri.parse(url));

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
      throw Exception('Failed to load any boards');
    }
  }
}
