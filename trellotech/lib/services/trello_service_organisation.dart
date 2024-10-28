import 'package:http/http.dart' as http;
import 'package:trellotech/env.dart';
import 'package:trellotech/models/trello_board.dart';
import 'dart:convert';
import 'package:trellotech/models/trello_organization.dart';
import 'package:trellotech/models/trello_token.dart';

class TrelloServiceOrganisation {
  late TrelloToken token;
  TrelloServiceOrganisation(this.token);

  // je crée une organisation
  Future<TrelloOrg> createOrganization(String displayName) async {
    final url = Uri.parse('https://api.trello.com/1/organizations')
        .replace(queryParameters: {
      'displayName': displayName,
      'desc': 'descriptiondelespace',
      'name': displayName,
      'website': 'epitech.eu',
      'key': Env.apikey,
      'token': token.token,
    });

    final response = await http.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return TrelloOrg.fromJson(data);
    } else {
      throw Exception('Failed to create organization');
    }
  }

  Future<List<TrelloOrg>> getOrganizations() async {
    Uri url = Uri.parse(
        'https://api.trello.com/1/members/me/organizations?key=${Env.apikey}&token=${token.token}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<TrelloOrg> organizations = [];
      for (var orgData in data) {
        String orgId = orgData['id'];

        // Récupérer les boards pour l'organisation
        List<TrelloBoard> boards = await getBoardsForOrganization(orgId);

        // Créer un objet TrelloOrg avec les boards récupérés
        TrelloOrg org = TrelloOrg(
          id: orgId,
          name: orgData['name'],
          boards: boards,
        );
        organizations.add(org);
      }

      return organizations;
    } else {
      throw Exception('Failed to load any organizations');
    }
  }

  // Récupère tous les boards pour un org donnée
  Future<List<TrelloBoard>> getBoardsForOrganization(
      String organizationId) async {
    Uri url = Uri.parse(
        'https://api.trello.com/1/organization/$organizationId/boards?key=${Env.apikey}&token=${token.token}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<TrelloBoard> boards = [];
      for (var boardData in data) {
        TrelloBoard board = TrelloBoard(
          id: boardData['id'],
          name: boardData['name'],
          lists: [],
        );
        boards.add(board);
      }
      return boards;
    } else {
      throw Exception('Failed to load any boards');
    }
  }

// je supprime l organisation
  Future<void> deleteOrganization(String organizationId) async {
    final url = Uri.parse(
        'https://api.trello.com/1/organizations/$organizationId?key=${Env.apikey}&token=${token.token}');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete organization');
    }
  }

  Future<void> updateOrganization(TrelloOrg organization) async {
    final url = Uri.parse(
        'https://api.trello.com/1/organizations/${organization.id}?key=${Env.apikey}&token=${token.token}');

    final body = {
      'name': organization.name,
      'displayName': organization.name,
      'desc': 'descriptiondelespace',
      'website': 'epitech.eu',
    };

    final response = await http.put(url, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to update organization');
    }
  }
}
