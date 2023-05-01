// import 'dart:js_util';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase/helpers/global_data.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../services/firestore_crud.dart';

// class Idcard extends StatelessWidget {
//   Idcard(this.uid);

//   // Map<String, String> user = {
//   //   'Name': 'Kaustubh Narendra Joshi',
//   //   "Branch": 'Computer Engineering',
//   //   'DOB': '15-07-2003',
//   //   'Validity': 'JULY 2021 - JUNE 2022'
//   // };
//   final Map<String, dynamic> _userData = {
//     'Name': '',
//     'Branch': '',
//     'DOB': '',
//     'UID': '',
//     'Phone': '',
//     'Blood Group': '',
//     'Gender': '',
//     'ImageURL': '',
//   };
//   final _db = FirebaseFirestore.instance;

//   final String uid;
//   Future<DocumentSnapshot> getUserData() async {
//     final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//     DocumentSnapshot documentSnapshot =
//         await _firebaseFirestore.collection('users').doc(uid).get();
//     return documentSnapshot;
//   }

//   @override
//   Widget build(BuildContext context) {
//     getUserData().then((DocumentSnapshot documentSnapshot) {
//       if (documentSnapshot.exists) {
//         // Get the data from the document
//         Map<String, dynamic>? data =
//             documentSnapshot.data() as Map<String, dynamic>?;
//         // Do something with the data
//         _userData['Name'] = data?['Name'];
//         _userData['Branch'] = data?['Branch'];
//         _userData['DOB'] = data?['DOB'];
//         _userData['Phone'] = data?['Phone'];
//       }
//     });
//     print("the uid got is so " + uid);
//     print(_userData['Name']);

    
// }

// Column(children: [
//                   // Image.file(ImageURL as File),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Scanned result ",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     " ${widget.code} ",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1),
//                   ),
//                   SizedBox(
//                     // width: MediaQuery.of(context).size.width,
//                     // height: MediaQuery.of(context).size.height,
//                     height: 50,
//                     child: Text("$Name  hello  + $Phone"),
//                   ),
//                 ]),