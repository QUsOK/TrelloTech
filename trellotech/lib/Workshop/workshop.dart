import 'package:flutter/material.dart';

class Workshop extends StatelessWidget {
  const Workshop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Sample d\'une carte')),
        body: const WorkshopContainer(),
      ),
    );
  }
}

class WorkshopContainer extends StatelessWidget {
  const WorkshopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            debugPrint('Carte cliquée.');
          },
          child: const SizedBox(
            width: 300,
            height: 100,
            child: Text('Une carte qui peut être cliquée.'),
          ),
        ),
      ),
    );
  }
}
