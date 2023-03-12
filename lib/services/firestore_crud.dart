import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import '../helpers/global_data.dart';

class Firestore {
  String path;
  late CollectionReference cr1;
  Firestore({required this.path}) {
    cr1 = FirebaseFirestore.instance.collection(path);
  }
  Future<void> post(Map<String, String> m) async {
    // return cr1.add(m);
    // print('DATA POSTING');
    return cr1.doc(m['UID']).set(m);
  }

  Future<List> fetchAll() async {
    List l = [];
    try {
      await cr1.get().then((querySnapshot) {
        // print(querySnapshot.size);
        var docs = querySnapshot.docs
            .forEach((e) => l.add(json.decode(json.encode(e.data()))));
      });
    } catch (error) {
      rethrow;
    }
    return l;
  }

  Future<Map> fetchID(String UID) async {
    return cr1
        .doc(UID)
        .get()
        .then((value) => json.decode(json.encode(value.data())));
  }

  Future<void> update(String UID, Map<String, String> m) async {
    try {
      await cr1.doc(UID).update(m);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> delete(String UID) async {
    try {
      await cr1.doc(UID).delete();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchClubID() async {
    return User.clubs.forEach(
      (key, value) async {
        var m = await cr1.doc(key).get();
        var x = (json.decode(json.encode(m.data())));
        User.clubs[key] = x['UID'].toString();
        // print(User.clubs[key]);
      },
    );
  }

  Future<void> putEvent(Map<String, String> event) async {
    return cr1
        .doc(event['club'])
        .collection('posts')
        .doc(event['title']!)
        .set(event);
  }

  Future<void> fetchClubEvents() async {
    User.events.forEach(
      (key, club_val) async {
        var snapshot = await cr1.doc(key).collection('posts').get();
        Map<String, Map<String, String>> event = {};
        for (int i = 0; i < snapshot.docs.length; i++) {
          event[snapshot.docs[i]['title']] = snapshot.docs[i].data().map(
              (eventkey, eventvalue) =>
                  MapEntry(eventkey.toString(), eventvalue.toString()));
        }
        User.events.update(key, (val) => event);
      },
    );
  }
}
