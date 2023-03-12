import 'package:firebase/screens/club_events.dart';
import 'package:firebase/services/firestore_crud.dart';
import 'package:flutter/material.dart';
import '../helpers/global_data.dart';

class Clubs extends StatefulWidget {
  Clubs({super.key});
  static const routeName = '/clubs_screen';
  List<String> l = ['PASC', 'PCSB', 'PISB', 'Pictoreal', 'GDU', 'GDSC'];

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  @override
  void initState() {
    Firestore(path: 'clubs').fetchClubEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CLUBS')),
      body: RefreshIndicator(
        onRefresh: () async {
          await Firestore(path: 'clubs').fetchClubEvents();
        },
        child: Center(
          child: ListView(
            children: widget.l.map((element) {
              return GestureDetector(
                onTap: () {
                  // print(User.events);
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
      ),
    );
  }
}
