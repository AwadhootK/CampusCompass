import 'dart:developer';

import 'package:firebase/helpers/global_data.dart';
import 'package:firebase/screens/BottomNavBar/logic/bottomnavbar_cubit.dart';
import 'package:firebase/screens/Canteen/admin/admin_main.dart';
import 'package:firebase/screens/Canteen/admin/admin_signup.dart';
import 'package:firebase/screens/Canteen/admin/logic/admin_cubit.dart';
import 'package:firebase/screens/Canteen/admin/logic/food_item_cubit.dart';
import 'package:firebase/screens/Canteen/canteen_menu.dart';
import 'package:firebase/screens/Clubs/logic/clubs_cubit.dart';
import 'package:firebase/screens/Clubs/ui/clubs_screen.dart';
import 'package:firebase/screens/Login/logic/login_cubit.dart';
import 'package:firebase/screens/QR%20Code%20+%20ID/Profile_screen.dart';
import 'package:firebase/screens/QR%20Code%20+%20ID/logic/result_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
          builder: (context, state) {
            if (state is BottomNavProfile) {
              return AppBar(
                title: const Text('Profile'),
                actions: [
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<AuthCubit>(context).logout();
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ],
              );
            } else if (state is BottomNavCanteen) {
              return AppBar(
                title: const Text('Canteen'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => AdminAuthCubit(),
                            child: AdminMain(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              );
            } else {
              return AppBar(
                title: const Text('Campus Compass'),
              );
            }
          },
        ),
      ),
      body: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          log(state.toString());
          if (state is BottomNavProfile) {
            return BlocProvider(
              create: (context) => ResultCubit()
                ..getUserData(
                  User.m!['UID'],
                ),
              child: ProfileScreen(),
            );
          } else if (state is BottomNavClubs) {
            return BlocProvider.value(
              value: BlocProvider.of<ClubsCubit>(context)..fetchClubEvents(),
              child: const ClubsScreen(),
            );
          } else if (state is BottomNavLibrary) {
            return Center(
              child: Container(
                color: Colors.blue,
                child: const Text('Library'),
              ),
            );
          } else if (state is BottomNavAttendance) {
            return Center(
              child: Container(
                color: Colors.green,
                child: const Text('Attendance'),
              ),
            );
          } else if (state is BottomNavCanteen) {
            return BlocProvider(
              create: (context) => FoodItemCubit()..fetchFoodItems(),
              child: CanteenMenu(),
            );
          } else {
            return Center(
              child: Container(
                color: Colors.red,
                child: const Text('Error'),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            BlocProvider.of<BottomNavBarCubit>(context).bottonNavBarIndex,
        onTap: (newIndex) => setState(() {
          BlocProvider.of<BottomNavBarCubit>(context).changeIndex(newIndex);
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Clubs',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Library',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Attendance',
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: 'Food',
              backgroundColor: Colors.purple),
        ],
      ),
    );
  }
}
