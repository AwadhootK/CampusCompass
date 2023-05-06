import 'dart:io' as Io;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:developer';
import 'dart:convert';

class IdCard extends StatefulWidget {
  final String code;
  final Function() closeScreen;
  const IdCard({super.key, required this.code, required this.closeScreen});

  @override
  State<IdCard> createState() => _IdCardState();
}

class _IdCardState extends State<IdCard> {
  String Name = "";
  String Branch = "";
  String DOB = "";
  String UID = "";
  String Phone = "";
  String Blood_Group = "";
  String Gender = "";
  String? ImageURL;
  // var decoded;
  bool exist = true;
  late Color _branchColor;
  final _db = FirebaseFirestore.instance;
  var isloading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      isloading = true;
    });

    getUserData().then((value) => setState(() {
          isloading = false;
          if (Branch == "IT") {
            _branchColor = Color.fromARGB(255, 32, 101, 157);
          } else if (Branch == "CE") {
            _branchColor = Colors.green.shade600;
          } else {
            _branchColor = Colors.pink.shade900;
          }
        }));
  }

  Future<void> getUserData() async {
    // Duration(microseconds: 2);
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await _firebaseFirestore.collection('users').doc(widget.code).get();
    try {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        Name = data['Name'];
        Branch = data['Branch'];
        Blood_Group = data['Blood Group'];
        Phone = data['Phone'];
        DOB = data['DOB'];
        ImageURL = data['ImageURL'];
        // log(ImageURL!);
      } else {}
    } catch (error) {
      exist = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String uid;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => {
                  widget.closeScreen(),
                  Navigator.pop(context),
                },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text(
          "Digital Id Card",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: (exist)
                    ? Id(Name, Branch, DOB, widget.code, Phone, ImageURL,
                        _branchColor)
                    : page(),
              ),
            ),
    );
  }
}

Widget page() {
  return Container(
    child: Center(child: Text("Data Not Found")),
  );
}

Widget Id(String Name, String branch, String DOB, String uid, String phone,
    var ImageURl, Color) {
  return Container(
    margin: EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              child: Center(
                child: Text(
                  "ID CARD VERIFIED",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.greenAccent.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Container(
              child: Icon(
                Icons.verified,
                color: Colors.green.shade700,
              ),
            )
          ],
        ),
        Container(
          height: 100,
          color: Color,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                color: Color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Text(
                      'Society for Computer Technology & Research\'s',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        child: Text(
                      'PUNE INSTITUTE OF',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                        child: Text(
                      'COMPUTER TECHNOLOGY',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 50, bottom: 10, left: 100, right: 100),
          width: 150,
          height: 150,
          color: Colors.grey,
          child: Image.memory(base64Decode('$ImageURl'!)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              Name,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Branch : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              branch,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ' D.O.B : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              DOB,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Reg.ID NO : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              uid.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Phone No : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              phone!,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 20,
          color: Color,
        ),
      ],
    ),
    color: Colors.white,
  );
}
