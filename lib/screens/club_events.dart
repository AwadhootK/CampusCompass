import 'dart:collection';

import 'package:firebase/screens/club_posts.dart';
import 'package:firebase/screens/event_description.dart';
import 'package:flutter/material.dart';

import '../services/firestore_crud.dart';
import '../helpers/global_data.dart';

class ClubEvent extends StatelessWidget {
  static const routeName = '/clubs_events';

  @override
  Widget build(BuildContext context) {
    String clubName = ModalRoute.of(context)!.settings.arguments as String;
    List<Map<String, String>> event = User.events[clubName]!.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(clubName),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            //Navigate
            Navigator.of(context)
                .pushNamed(EventDescription.routeName, arguments: event[index]);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: 50,
            color: Colors.blue[200],
            child:
                Center(child: Text(event[index]['title'] ?? 'Unnamed Event')),
          ),
        ),
        itemCount: event.length,
      ),
      floatingActionButton: (User.m!['UID'] == User.clubs[clubName])
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ClubsForm.routeName, arguments: clubName);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
