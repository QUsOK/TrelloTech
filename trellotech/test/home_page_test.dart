import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trellotech/home/home_page.dart';
import 'package:trellotech/models/trello_token.dart';

void main() {
  testWidgets('HomePage fait une action qui ouvre la modale',
      (WidgetTester tester) async {
    TrelloToken token = TrelloToken(token: "");

    await tester.pumpWidget(MaterialApp(
        home: HomePage(
      token: token,
    )));

    // Vérifie que le bouton flottant d'ajout est présent
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Appuie sur le bouton flottant d'ajout
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Vérifie que la boîte de dialogue est affichée
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Créer une nouvelle organisation'), findsOneWidget);
  });
}
