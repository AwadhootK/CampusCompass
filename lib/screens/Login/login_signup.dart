import 'dart:developer';

import 'package:firebase/screens/Canteen/admin/admin_main.dart';
import 'package:firebase/screens/Canteen/admin/logic/admin_cubit.dart';
import 'package:firebase/screens/Login/logic/login_cubit.dart';
import 'package:firebase/screens/QR%20Code%20+%20ID/Qr_Scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/myException.dart';
import 'sign_up.dart';

enum formState { login, signUp }

class LoginSignup extends StatefulWidget {
  LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final _key = GlobalKey<FormState>();
  final Map<String, String> _user = {'username': '', 'password': ''};
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  formState state = formState.login;

  void _showErrorDialog(String errorMsg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('An Error Occured!'),
        content: Text(errorMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Okay'),
          )
        ],
      ),
    );
  }

  Future<void> _saveForm() async {
    // setState(() {
    //   _isLoading = true;
    // });
    log('saving form');
    log('FORM State: ${state.toString()}');
    final isValid = _key.currentState!.validate();
    if (!isValid) return;
    _key.currentState!.save();
    try {
      if (state == formState.login) {
        // log('saving form in login');
        await BlocProvider.of<AuthCubit>(context).login(
          _user['username']!,
          _user['password']!,
        );
        // log('saving form in login done');
      } else if (state == formState.signUp) {
        // final nav = Navigator.of(context);
        await BlocProvider.of<AuthCubit>(context).signup(
          _user['username']!,
          _user['password']!,
        );
        // log('done saving form');
        // nav.push(MaterialPageRoute(builder: (context) => SignUp()));
      }
    } on httpException catch (error) {
      log(error.toString());
      log('some error occurred');
      BlocProvider.of<AuthCubit>(context).emitError(error.toString());
      // setState(() {
      //   _isLoading = false;
      // });
      var errorMsg = 'Authentication Failed! Please try again later...';
      if (error.exception.contains('EMAIL_EXISTS')) {
        errorMsg = 'Email already exists! Please login...';
      } else if (error.exception.contains('INVALID_EMAIL')) {
        errorMsg = 'This is not a valid email address!';
      } else if (error.exception.contains('WEAK_PASSWORD')) {
        errorMsg = 'This password is too weak!';
      } else if (error.exception.contains('EMAIL_NOT_FOUND')) {
        errorMsg = 'Could not find a user with that email!';
      } else if (error.exception.contains('INVALID_PASSWORD')) {
        errorMsg = 'Please enter a valid password!';
      }
      _showErrorDialog(errorMsg);
      Navigator.of(context).pop();
    } catch (error) {
      // setState(() {
      //   _isLoading = false;
      // });
      _showErrorDialog('Authentication Failed! Please try again later...');
      Navigator.of(context).pop();
    }
  }

  void _toggleFormState() {
    if (state == formState.login) {
      setState(() {
        state = formState.signUp;
      });
    } else if (state == formState.signUp) {
      setState(() {
        state = formState.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.blue,
              ),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: state == formState.login ? 350 : 400,
              width: 300,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.blue[200],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text('Enter Username')),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null) return 'Value is a null';
                            if (value.isEmpty) {
                              return 'Please provide a value';
                            }
                            if (!((value.startsWith('C') ||
                                    value.startsWith('I') ||
                                    value.startsWith('E')) &&
                                value.length == 11 &&
                                value[2] == 'K')) {
                              return 'Please enter a valid Reg.ID number';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _user['username'] =
                                '${newValue!.toUpperCase()}@pict.edu';
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text('Enter Password')),
                          obscureText: true,
                          controller: passwordController,
                          textInputAction: state == formState.login
                              ? TextInputAction.done
                              : TextInputAction.next,
                          validator: (value) {
                            if (value == null) return 'Value is null';
                            if (value.isEmpty) return 'Please provide a value';
                            return null;
                          },
                          onSaved: (newValue) {
                            _user['password'] = newValue!;
                          },
                          onFieldSubmitted: (_) =>
                              state == formState.login ? _saveForm() : null,
                        ),
                        if (state == formState.signUp)
                          TextFormField(
                            decoration: const InputDecoration(
                                label: Text('Confirm Password')),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null) return 'Value is null';
                              if (value.isEmpty) {
                                return 'Please Re-Enter Password!';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                          ),
                        const SizedBox(
                          height: 30,
                        ),
                        // if (state == formState.signUp) SignUp(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Card(
                              child: TextButton(
                                  onPressed: state == formState.login
                                      ? _saveForm
                                      : _toggleFormState,
                                  child: const Text('Login')),
                            ),
                            Card(
                              child: TextButton(
                                  onPressed: state == formState.signUp
                                      ? _saveForm
                                      : _toggleFormState,
                                  // onPressed: () => Navigator.of(context)
                                  //     .pushNamed(SignUp.routeName),
                                  child: const Text('Sign Up')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Card(
                //   color: Colors.blue,
                //   child: TextButton(
                //     onPressed: () => Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => ScanQr(isLogin: false),
                //       ),
                //     ),
                //     child: const Text(
                //       'Verify QR Code',
                //       style: TextStyle(
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                newButton(
                  'Verify QR Code',
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScanQr(isLogin: false),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                newButton(
                  'Sign In as Admin',
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => AdminAuthCubit(),
                        child: AdminMain(),
                      ),
                    ),
                  ),
                ),
                // Card(
                //   color: Colors.blue,
                //   child: TextButton(
                //     onPressed: () => Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => BlocProvider(
                //           create: (context) => AdminAuthCubit(),
                //           child: AdminMain(),
                //         ),
                //       ),
                //     ),
                //     child: const Text(
                //       'Sign In as Admin',
                //       style: TextStyle(
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget newButton(String text, Function onPressed) {
  return ElevatedButton(
    onPressed: () => onPressed(),
    style: ElevatedButton.styleFrom(
      backgroundColor:
          Colors.blue[500], // Change the background color of the button
      foregroundColor: Colors.white, // Change the text color of the button
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            12), // Adjust the border radius to make it more or less round
      ),
      elevation: 3, // Add a shadow to the button
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
