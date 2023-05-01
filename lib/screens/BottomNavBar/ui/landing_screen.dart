import 'dart:developer';

import 'package:firebase/home_screen.dart';
import 'package:firebase/screens/BottomNavBar/logic/bottomnavbar_cubit.dart';
import 'package:firebase/screens/Clubs/logic/clubs_cubit.dart';
import 'package:firebase/screens/Clubs/ui/clubs_screen.dart';
import 'package:firebase/screens/Login/logic/login_cubit.dart';
import 'package:firebase/screens/QR%20Code%20+%20ID/Profile_screen.dart';
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
      appBar: AppBar(
        title: const Text('Campus Compass'),
        actions: [
          IconButton(
            onPressed: () => BlocProvider.of<AuthCubit>(context).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          log(state.toString());
          if (state is BottomNavProfile) {
            return ProfileScreen();
          } else if (state is BottomNavClubs) {
            return BlocProvider.value(
              value: BlocProvider.of<ClubsCubit>(context)..fetchClubEvents(),
              child: ClubsScreen(),
            );
          } else if (state is BottomNavLibrary) {
            return Center(
              child: Container(
                color: Colors.blue,
                child: Text('Library'),
              ),
            );
          } else if (state is BottomNavAttendance) {
            return Center(
              child: Container(
                color: Colors.green,
                child: Text('Attendance'),
              ),
            );
          } else {
            return Center(
              child: Container(
                color: Colors.red,
                child: Text('Error'),
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
        ],
      ),
    );
  }
}
