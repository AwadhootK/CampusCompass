import 'dart:developer';

import 'package:CampusCompass/helpers/global_data.dart';
import 'package:CampusCompass/screens/QR%20Code%20+%20ID/logic/result_cubit.dart';
import './ui/flip_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _size = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<ResultCubit, ResultState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ResultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResultLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FlipWidget(
                    code: User.m!['UID'],
                    isLogin: true,
                  ),
                ],
              ),
            );
          } else if (state is ResultError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
