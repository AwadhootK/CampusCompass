//Not needed

// import 'package:firebase/screens/Login/logic/login_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:convert';
// import 'dart:developer';

// import 'helpers/global_data.dart';

// class HomeScreen extends StatefulWidget {
//   HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   var _size = 300;

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthCubit, LoginState>(
//       listener: (context, state) {
//         if (state is SignUpSuccessful) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Sign Up Successful'),
//               duration: Duration(seconds: 2),
//               backgroundColor: Colors.green,
//             ),
//           );
//         } else if (state is LoginSuccessState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Login Successful'),
//               duration: Duration(seconds: 2),
//               backgroundColor: Colors.blue,
//             ),
//           );
//         } else if (state is UserDataPosted) {
//           setState(() {
//             User.m = state.userData;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Sign Up Successful'),
//               duration: Duration(seconds: 2),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: Colors.white,
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text('WELCOME TO THE APP'),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ElevatedButton(
//                     onPressed: () => setState(() {
//                           log(User.m!['ImageURL']);
//                         }),
//                     child: const Text('REFRESH')),
//                 SizedBox(
//                   height: _size.toDouble(),
//                   width: _size.toDouble(),
//                   child: User.m == null
//                       ? Container(
//                           color: Colors.blue,
//                         )
//                       : Image.memory(
//                           base64Decode(
//                             User.m!['ImageURL']!,
//                           ),
//                           height: _size.toDouble(),
//                           width: _size.toDouble(),
//                         ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => BlocProvider.of<AuthCubit>(context).logout(),
//                   child: const Text('Log Out'),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
