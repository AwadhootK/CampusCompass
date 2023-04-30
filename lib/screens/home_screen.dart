import 'package:firebase/screens/Clubs/clubs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../providers/auth.dart';
import '../services/firestore_crud.dart';
import '../helpers/global_data.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            const Text('WELCOME TO THE APP'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => setState(() {
                      print(User.m!['ImageURL']);
                    }),
                child: const Text('REFRESH')),
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: _size.toDouble(),
              width: _size.toDouble(),
              child: InkWell(
                onTap: () => setState(() {
                  _size = 100;
                }),
                onDoubleTap: () => setState(() {
                  _size = 500;
                }),
                child: User.m == null
                    ? Container(
                        color: Colors.blue,
                      )
                    : Image.memory(
                        base64Decode(
                          User.m!['ImageURL']!,
                        ),
                        height: _size.toDouble(),
                        width: _size.toDouble(),
                      ),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  Provider.of<Auth>(context, listen: false).logout(),
              child: const Text('Log Out'),
            )
          ],
        ),
      ),
    );
  }
}
