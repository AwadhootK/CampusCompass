import 'dart:developer';
import 'package:CampusCompass/screens/QR%20Code%20+%20ID/logic/result_cubit.dart';
import 'package:flutter/material.dart';
import './id_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultScreen extends StatefulWidget {
  final String code;
  final bool isLogin;

  const ResultScreen({
    super.key,
    required this.code,
    required this.isLogin,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResultCubit, ResultState>(
      builder: (context, state) {
        if (state is ResultLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ResultLoaded) {
          if (!widget.isLogin) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  const Text(
                    'Your ID Card',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  IDCard(
                    state.result['Name'],
                    state.result['Branch'],
                    state.result['DOB'],
                    widget.code,
                    state.result['Phone'],
                    state.result['ImageURL'],
                    state.result['Branch'] == 'CE'
                        ? Colors.green
                        : state.result['Branch'] == 'IT'
                            ? Colors.blue
                            : Colors.purple,
                  ),
                ],
              ),
            );
          } else {
            return IDCard(
              state.result['Name'],
              state.result['Branch'],
              state.result['DOB'],
              widget.code,
              state.result['Phone'],
              state.result['ImageURL'],
              state.result['Branch'] == 'CE'
                  ? Colors.green
                  : state.result['Branch'] == 'IT'
                      ? Colors.blue
                      : Colors.purple,
            );
          }
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
      listener: (context, state) {
        if (state is ResultError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.message),
            ),
          );
        }
      },
    );
  }
}
