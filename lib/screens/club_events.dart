import 'package:flutter/material.dart';

import '../services/firestore_crud.dart';
import '../helpers/global_data.dart';

class ClubEvent extends StatelessWidget {
  static const routeName = '/clubs_events';
  const ClubEvent({super.key});
  @override
  Widget build(BuildContext context) {
    String clubName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(clubName),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Firestore(path: 'clubs').fetchClubID();
          },
          child: const Text('VIEW ID'),
        ),
      ),
      floatingActionButton: (User.m!['UID'] == User.clubs[clubName])
          ? FloatingActionButton(
              onPressed: () {
                print('yes!!');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
