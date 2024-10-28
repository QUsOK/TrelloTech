import 'package:flutter/material.dart';
import 'package:trellotech/Login/trello_login.dart';
import 'package:trellotech/env.dart';
import 'package:trellotech/home/home_page.dart';
import 'package:trellotech/models/trello_token.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const TrelloTechApp());
}

class TrelloTechApp extends StatelessWidget {
  const TrelloTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TrelloTech',
      home: AccueilPage(),
    );
  }
}

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  late TextEditingController _tokenController = TextEditingController();
  late TrelloToken token = TrelloToken(token: '');

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController();
  }

  @override
  void dispose() {
    token.token = _tokenController.text;
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Webview Example'),
                      ),
                      body: WebViewWidget(
                        controller: TrelloLoginPage().connexion(context),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20, width: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.5, // Remplacez cette valeur par la largeur souhaitée
              child: TextField(
                controller: _tokenController,
                decoration: const InputDecoration(
                    labelText: 'Enter token', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 20, width: 20),
            ElevatedButton(
              onPressed: () {
                token.token = _tokenController.text;
                if (token.token.isEmpty) {
                  token.token = Env.token;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(token: token),
                  ),
                );
              },
              child: const Text('Token'),
            ),
          ],
        ),
      ),
    );
  }
}
