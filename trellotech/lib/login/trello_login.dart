import 'package:trellotech/env.dart';
import 'package:trellotech/home/home_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:trellotech/models/trello_token.dart';

class TrelloLoginPage {
  WebViewController connexion(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://trello.com/1/token/approve')) {
              String fragment = request.url.split('=')[1];
              TrelloToken token = TrelloToken(token: fragment);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(token: token),
                ),
              );
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "https://trello.com/1/authorize?key=${Env.apikey}&expiration=never&response_type=token&scope=read,write&return_url=https://trello.com/1/token/approve"));
    return controller;
  }
}
