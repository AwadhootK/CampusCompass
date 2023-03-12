import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/login_signup.dart';
import './providers/auth.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';
import './screens/sign_up.dart';
import './screens/clubs_screen.dart';
import './screens/club_events.dart';
import './screens/event_description.dart';
import './screens/club_posts.dart';

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
        builder: (context, authObj, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: authObj.isAuth()
              ? Clubs()
              : FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SplashScreen();
                    }
                    if (snapshot.data == true) {
                      print('logged');
                      return Clubs();
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
            Clubs.routeName: (context) => Clubs(),
            EventDescription.routeName: (context) => EventDescription(),
            ClubsForm.routeName: (context) => ClubsForm(),
          },
        ),
      ),
    );
  }
}
