import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/library/libraryRecords.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../helpers/global_data.dart';
import './lib_form.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  List<Map<dynamic, dynamic>> l = [];
  CollectionReference cr1 = FirebaseFirestore.instance.collection('library');
  Future<List> fetchAll() async {
    try {
      await cr1.get().then((querySnapshot) {
        // print(querySnapshot.size);
        var docs = querySnapshot.docs.forEach((e) {
          if (e.id == User.m!['UID'].toString().substring(0, 11)) {
            l.add(json.decode(json.encode(e.data())));
          }
        });
      });
    } catch (error) {
      rethrow;
    }
    print(l);
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: l.length,
          itemBuilder: (context, index) {
            setstate() {
              fetchAll();
              return LibraryCardWidget(l[index]);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (context) => LibraryForm());
        },
      ),
    );
  }
}
