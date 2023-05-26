import 'dart:developer';

import 'package:CampusCompass/helpers/global_data.dart';
import 'package:CampusCompass/screens/Attendance/Attendance_screen.dart';
import 'package:CampusCompass/screens/Attendance/logic/attendance_cubit.dart';
import 'package:CampusCompass/screens/Attendance/widgets/subject_card.dart';
import 'package:CampusCompass/screens/BottomNavBar/logic/bottomnavbar_cubit.dart';
import 'package:CampusCompass/screens/Canteen/admin/logic/daily_item_cubit.dart';
import 'package:CampusCompass/screens/Canteen/admin/logic/food_item_cubit.dart';
import 'package:CampusCompass/screens/Canteen/canteen_menu.dart';
import 'package:CampusCompass/screens/Clubs/logic/clubs_cubit.dart';
import 'package:CampusCompass/screens/Clubs/ui/clubs_screen.dart';
import 'package:CampusCompass/screens/Library/logic/library_cubit.dart';
import 'package:CampusCompass/screens/Library/ui/library_screen.dart';
import 'package:CampusCompass/screens/Login/logic/login_cubit.dart';
import 'package:CampusCompass/screens/QR%20Code%20+%20ID/Profile_screen.dart';
import 'package:CampusCompass/screens/QR%20Code%20+%20ID/logic/result_cubit.dart';
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
                backgroundColor: Colors.blue,
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
                backgroundColor: Colors.black54,
                title: const Text('Clubs'),
                centerTitle: true,
              );
            } else if (state is BottomNavLibrary) {
              return AppBar(
                backgroundColor: Colors.green,
                title: const Text('Library'),
                centerTitle: true,
              );
            } else if (state is BottomNavAttendance) {
              return AppBar(
                backgroundColor: Colors.pinkAccent,
                title: const Text('Attendance'),
                centerTitle: true,
              );
            } else if (state is BottomNavCanteen) {
              return AppBar(
                backgroundColor: Colors.purple[300],
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Clubs',
            backgroundColor: Colors.black54,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Library',
            backgroundColor: Colors.green,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Attendance',
            backgroundColor: Colors.pinkAccent,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.food_bank),
            label: 'Canteen',
            backgroundColor: Colors.purple[300],
          ),
        ],
      ),
    );
  }
}
