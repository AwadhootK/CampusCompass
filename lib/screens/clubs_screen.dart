import 'package:firebase/screens/club_events.dart';
import 'package:flutter/material.dart';

class Clubs extends StatelessWidget {
  Clubs({super.key});
  static const routeName = '/clubs_screen';
  List<String> l = ['PASC', 'PCSB', 'PISB', 'Pictoreal', 'GDU', 'GDSC'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CLUBS')),
      body: Center(
        child: ListView(
          children: l.map((element) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(ClubEvent.routeName, arguments: element);
              },
              child: Card(
                elevation: 10,
                shadowColor: Colors.blue[900],
                child: Container(
                  height: 50,
                  color: Colors.blue[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(element),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
