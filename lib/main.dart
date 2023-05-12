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
        home: BlocConsumer<AuthCubit, LoginState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is LoginSuccessState ||
                state is SignUpSuccessful ||
                state is UserDataPosted) {
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
            } else if (state is LoginFailedState) {
              return BlocConsumer<AuthCubit, LoginState>(
                bloc: BlocProvider.of<AuthCubit>(context)..tryAutoLogin(),
                builder: (context, state) {
                  if (state is LoginSuccessState ||
                      state is SignUpSuccessful ||
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
                  } else if (state is LoginFailedState) {
                    return LoginSignup();
                  } else {
                    return const SplashScreen();
                  }
                },
                listener: (context, state) {},
              );
            } else if (state is LogOutState) {
              return LoginSignup();
            } else if (state is LoginError) {
              return Center(child: Text(state.error.toString()));
            } else {
              return const SplashScreen();
            }
          },
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
    );
  }
}