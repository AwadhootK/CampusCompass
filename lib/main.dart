// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(myApp());
// }

// class myApp extends StatelessWidget {
//   const myApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         child: IconButton(
//           icon: const Icon(Icons.upload),
//           onPressed: () async {
//             CollectionReference users =
//                 FirebaseFirestore.instance.collection('users');
//             await users.add({'age': '30', 'name': 'ABCD'}).then(
//                 (value) => print('user added successfully'));
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/login_signup.dart';
import './providers/auth.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';
import './screens/sign_up.dart';

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
              ? const HomeScreen()
              : FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SplashScreen();
                    }
                    if (snapshot.data == true) {
                      return const HomeScreen();
                    } else {
                      return LoginSignup();
                    }
                  },
                  future: authObj.tryAutoLogin(),
                ),
          routes: {
            SignUp.routeName: (context) => SignUp(),
          },
        ),
      ),
    );
  }
}
