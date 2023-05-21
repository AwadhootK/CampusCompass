import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

class EventDetailsWidget extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String posterUrl;

  const EventDetailsWidget({
    required this.title,
    required this.description,
    required this.date,
    required this.posterUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
            ),
            child: Container(
              height: 500,
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Hero(
                    tag: posterUrl,
                    child: Image.memory(
                      base64Decode(posterUrl),
                      fit: BoxFit.cover,
                      height: 200.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Date: $date',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventDescription extends StatelessWidget {
  static const routeName = '/event_description';

  @override
  Widget build(BuildContext context) {
    Map<String, String> event =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(event['title']!.toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: EventDetailsWidget(
          title: event['title']!,
          description: event['description']!,
          date: event['date']!,
          posterUrl: event['poster']!,
        ),
      ),
    );
  }
}
