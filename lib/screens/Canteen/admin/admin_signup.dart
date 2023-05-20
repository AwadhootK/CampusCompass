import 'package:firebase/screens/Canteen/admin/logic/admin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helpers/myException.dart';

class AdminLoginSignup extends StatefulWidget {
  AdminLoginSignup({super.key});

  @override
  State<AdminLoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<AdminLoginSignup> {
  final _key = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  var _isLoading = false;

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

  Future<void> _saveForm(String code) async {
    final isValid = _key.currentState!.validate();
    if (!isValid) return;
    _key.currentState!.save();
    try {
      await BlocProvider.of<AdminAuthCubit>(context).authenticateAdmin(code);
      Navigator.of(context).pop();
    } on httpException catch (error) {
      setState(() {
        _isLoading = false;
      });
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
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Authentication Failed! Please try again later...');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.green,
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: 300,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.green[200],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Form(
                          key: _key,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                  decoration: const InputDecoration(
                                      label: Text('Enter Admin Code')),
                                  obscureText: true,
                                  controller: passwordController,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value == null) return 'Value is null';
                                    if (value.isEmpty) {
                                      return 'Please provide a value';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) =>
                                      _saveForm(passwordController.text)),
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
              ],
            ),
    );
  }
}
