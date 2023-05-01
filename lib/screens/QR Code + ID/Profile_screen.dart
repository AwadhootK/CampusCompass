import 'package:firebase/helpers/global_data.dart';
import 'package:firebase/screens/QR%20Code%20+%20ID/result_screen.dart';

import 'QrCode.dart';
import 'Qr_Scan.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _size = 300;

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 5,
            ),
            FlipWidget(code: User.m!['UID']),
          ],
        ),
      ),
    );
  }
}
