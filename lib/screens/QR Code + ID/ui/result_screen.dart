import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/helpers/global_data.dart';
import 'package:firebase/screens/QR%20Code%20+%20ID/QrCode.dart';
import 'package:firebase/screens/QR%20Code%20+%20ID/logic/result_cubit.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';

class FlipWidget extends StatefulWidget {
  @override
  _FlipWidgetState createState() => _FlipWidgetState();
}

class _FlipWidgetState extends State<FlipWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFrontVisible = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFrontVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    setState(() {
      _isFrontVisible = !_isFrontVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _toggleCard,
          child: Text(
            _isFrontVisible ? 'Generate QR Code' : 'View ID',
          ),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(math.pi * _animation.value),
                child: _isFrontVisible
                    ? SizedBox(
                        child: ResultScreen(),
                      )
                    : const QrCode(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ResultScreen extends StatefulWidget {
  // final String code;
  // final Function() closeScreen;
  final bool? isScaned;
  const ResultScreen(
      {super.key,
      // required this.code,
      // required this.closeScreen,
      this.isScaned});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _db = FirebaseFirestore.instance;
  var isloading = false;
  var _isBack = false;

  @override
  Widget build(BuildContext context) {
    final String uid;

    return widget.isScaned != null
        ? Scaffold(
            appBar: AppBar(
              title: const Text('VERIFY QR CODE'),
              centerTitle: true,
            ),
            body: BlocBuilder<ResultCubit, ResultState>(
              bloc: BlocProvider.of<ResultCubit>(context)
                ..getUserData(User.m!['id']),
              builder: (context, state) {
                if (state is ResultLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ResultLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(25),
                    child: SingleChildScrollView(
                      child: Id(
                        state.result['Name'],
                        state.result['Branch'],
                        state.result['DOB'],
                        User.m!['id'],
                        state.result['Phone'],
                        state.result['ImageURL'],
                      ),
                    ),
                  );
                } else {
                  return page();
                }
              },
            ),
          )
        : BlocBuilder<ResultCubit, ResultState>(builder: (context, state) {
            if (state is ResultLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ResultLoaded) {
              return Padding(
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  child: Id(
                    state.result['Name'],
                    state.result['Branch'],
                    state.result['DOB'],
                    User.m!['id'],
                    state.result['Phone'],
                    state.result['ImageURL'],
                  ),
                ),
              );
            } else {
              return page();
            }
          });
  }
}

Widget page() {
  return const Center(child: Text("Data Not Found"));
}

Widget Id(String Name, String branch, String DOB, String uid, String phone,
    var ImageURl) {
  return Container(
    margin: const EdgeInsets.all(10),
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 100,
          color: branch == "IT"
              ? Colors.blue
              : branch == "CE"
                  ? Colors.green
                  : Colors.purple,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                color: branch == "IT"
                    ? Colors.blue
                    : branch == "CE"
                        ? Colors.green
                        : Colors.purple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Society for Computer Technology & Research\'s',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'PUNE INSTITUTE OF',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'COMPUTER TECHNOLOGY',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin:
              const EdgeInsets.only(top: 50, bottom: 10, left: 100, right: 100),
          // width: 150,
          height: 150,
          color: Colors.grey,
          child: Image.memory(
            fit: BoxFit.cover,
            base64Decode(
              '$ImageURl',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Name : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              Name,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Branch : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              branch,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              ' D.O.B : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              DOB,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Reg.ID NO : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              uid.toString(),
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Phone No : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              phone,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          height: 20,
          color: branch == "IT"
              ? Colors.blue
              : branch == "CE"
                  ? Colors.green
                  : Colors.purple,
        ),
      ],
    ),
  );
}
