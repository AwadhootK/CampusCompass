import 'dart:convert';

import 'package:flutter/material.dart';

class EventDescription extends StatelessWidget {
  static const routeName = '/event_description';

  @override
  Widget build(BuildContext context) {
    Map<String, String> event =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(title: Text(event['title']!.toUpperCase())),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Image.memory(base64Decode(event['poster']!)),
            Text(event['title']!),
            Text(event['description']!),
            Text(event['date']!),
          ],
        ),
      ),
    );
  }
}
