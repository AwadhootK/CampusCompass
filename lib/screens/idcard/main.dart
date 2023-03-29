import 'package:flutter/material.dart';
import './idcard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      home: Scaffold
      (
        appBar: AppBar(title: Text('DIGITAL ID'),),
        backgroundColor: Color.fromARGB(255, 137, 199, 230),
        body: Column(children:[ 
          Center(child: Idcard('C2K21107007')),
        ]),
      ),
    );
  }
}

