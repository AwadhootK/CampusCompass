import 'package:firebase/screens/Clubs/logic/clubs_cubit.dart';
import 'package:firebase/screens/Clubs/ui/clubs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer';

import 'screens/Login/login_signup.dart';
import './providers/auth.dart';
import 'screens/Login/splash_screen.dart';
import 'screens/Login/sign_up.dart';
import 'screens/Clubs/clubs_screen.dart';
import 'screens/Clubs/ui/club_events.dart';
import 'screens/Clubs/ui/event_description.dart';
import 'screens/Clubs/ui/club_posts.dart';

void main() async {
  // Initialize the firestore database
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, authObj, _) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ClubsCubit()..fetchClubEvents(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: authObj.isAuth()
                ? const ClubsScreen()
                : FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SplashScreen();
                      }
                      if (snapshot.data == true) {
                        log('logged in');
                        return const ClubsScreen();
                      } else {
                        return LoginSignup();
                      }
                    },
                    future: authObj.tryAutoLogin(),
                  ),
            routes: {
              // '/': (context) => ClubEvent(),
              SignUp.routeName: (context) => SignUp(),
              ClubEvent.routeName: (context) => ClubEvent(),
              ClubsScreen.routeName: (context) => ClubsScreen(),
              EventDescription.routeName: (context) => EventDescription(),
              ClubsForm.routeName: (context) => ClubsForm(),
            },
          ),
        ),
      ),
    );
  }
}
