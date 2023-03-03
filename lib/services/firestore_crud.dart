import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

class Firestore {
  static CollectionReference cr =
      FirebaseFirestore.instance.collection('users');

  static Future<void> post(Map<String, String> m) async {
    // return cr.add(m);
    print('DATA POSTING');
    return cr.doc(m['UID']).set(m);
  }

  static Future<List> fetchAll() async {
    List l = [];
    try {
      await cr.get().then((querySnapshot) {
        // print(querySnapshot.size);
        var docs = querySnapshot.docs
            .forEach((e) => l.add(json.decode(json.encode(e.data()))));
      });
    } catch (error) {
      rethrow;
    }
    return l;
  }

  static Future<Map> fetchID(String UID) async {
    return cr
        .doc(UID)
        .get()
        .then((value) => json.decode(json.encode(value.data())));
  }

  static Future<void> update(String UID, Map<String, String> m) async {
    try {
      await cr.doc(UID).update(m);
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> delete(String UID) async {
    try {
      await cr.doc(UID).delete();
    } catch (error) {
      rethrow;
    }
  }
}
