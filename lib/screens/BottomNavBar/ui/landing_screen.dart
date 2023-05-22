import 'dart:developer';

import 'package:firebase/helpers/global_data.dart';
import 'package:firebase/screens/Attendance/Attendance_screen.dart';
import 'package:firebase/screens/Attendance/logic/attendance_cubit.dart';
import 'package:firebase/screens/Attendance/widgets/subject_card.dart';
import 'package:firebase/screens/BottomNavBar/logic/bottomnavbar_cubit.dart';
import 'package:firebase/screens/Canteen/admin/logic/daily_item_cubit.dart';
import 'package:firebase/screens/Canteen/admin/logic/food_item_cubit.dart';
import 'package:firebase/screens/Canteen/canteen_menu.dart';
import 'package:firebase/screens/Clubs/logic/clubs_cubit.dart';
import 'package:firebase/screens/Clubs/ui/clubs_screen.dart';
import 'package:firebase/screens/Library/logic/library_cubit.dart';
import 'package:firebase/screens/Library/ui/library_screen.dart';
import 'package:firebase/screens/Login/logic/login_cubit.dart';
import 'package:firebase/screens/QR%20Code%20+%20ID/Profile_screen.dart';
import 'package:firebase/screens/QR%20Code%20+%20ID/logic/result_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
          builder: (context, state) {
            if (state is BottomNavProfile) {
              return AppBar(
                title: const Text('Profile'),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<AuthCubit>(context).logout();
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ],
              );
            } else if (state is BottomNavClubs) {
              return AppBar(
                title: const Text('Clubs'),
                centerTitle: true,
              );
            } else if (state is BottomNavLibrary) {
              return AppBar(
                title: const Text('Library'),
                centerTitle: true,
              );
            } else if (state is BottomNavAttendance) {
              return AppBar(
                title: const Text('Attendance'),
                centerTitle: true,
              );
            } else if (state is BottomNavCanteen) {
              return AppBar(
                title: const Text('Canteen'),
                centerTitle: true,
              );
            } else {
              return AppBar(
                title: const Text('Campus Compass'),
                centerTitle: true,
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
              child: BlocProvider(
                create: (ctx) => LibraryBloc(),
                child: LibraryScreen(),
              ),
            );
          } else if (state is BottomNavAttendance) {
            return BlocProvider.value(
              value: BlocProvider.of<AttendanceCubit>(context),
              child: AttendanceScreen(),
            );
          } else if (state is BottomNavCanteen) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => FoodItemCubit()..fetchFoodItems(),
                ),
                BlocProvider(
                  create: (context) => DailyItemCubit()..getDailyMenu(),
                ),
              ],
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
