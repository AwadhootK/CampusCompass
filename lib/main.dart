import 'dart:developer';

import 'package:firebase/screens/BottomNavBar/logic/bottomnavbar_cubit.dart';
import 'package:firebase/screens/BottomNavBar/ui/landing_screen.dart';
import 'package:firebase/screens/Clubs/logic/clubs_cubit.dart';
import 'package:firebase/screens/Clubs/ui/clubs_screen.dart';
import 'package:firebase/screens/Login/logic/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/Login/login_signup.dart';
import 'screens/Login/splash_screen.dart';
import 'screens/Login/sign_up.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit()..isAuth(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AuthCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(state.error.toString()),
                    duration: const Duration(seconds: 3),
                  ),
                );
            }
          },
          builder: (context, state) {
            log('State is: ${state.toString()}');
            if (state is LoginSuccessState || state is UserDataPosted) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ClubsCubit(),
                  ),
                  BlocProvider(
                    create: (context) => BottomNavBarCubit()..changeIndex(0),
                  ),
                ],
                child: const LandingPage(),
              );
            } else if (state is SignUpSuccessful) {
              return SignUp();
            } else if (state is LoginFailedState) {
              return BlocConsumer<AuthCubit, LoginState>(
                bloc: BlocProvider.of<AuthCubit>(context)..tryAutoLogin(),
                builder: (context, state) {
                  log('state2 is : ${state.toString()}');
                  if (state is TryLoginSuccessState ||
                      state is UserDataPosted) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => ClubsCubit(),
                        ),
                        BlocProvider(
                          create: (context) =>
                              BottomNavBarCubit()..changeIndex(0),
                        ),
                      ],
                      child: const LandingPage(),
                    );
                  } else if (state is TryLoginFailedState ||
                      state is TryLoginError ||
                      state is LoginError) {
                    return LoginSignup();
                  } else {
                    return const SplashScreen();
                  }
                },
                listener: (context, state) {
                  if (state is LoginError) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(state.error.toString()),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                  }
                },
              );
            } else if (state is LogOutState ||
                state is LoginError ||
                state is TryLoginFailedState) {
              return LoginSignup();
            } else if (state is TryLoginError) {
              return LoginSignup();
            } else {
              return const SplashScreen();
            }
          },
        ),
        routes: {
          SignUp.routeName: (context) => SignUp(),
          ClubEvent.routeName: (context) => ClubEvent(),
          ClubsScreen.routeName: (context) => ClubsScreen(),
          EventDescription.routeName: (context) => EventDescription(),
          ClubsForm.routeName: (context) => ClubsForm(),
        },
      ),
    );
  }
}
