import 'dart:convert';

import 'package:firebase/screens/Login/logic/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../helpers/global_data.dart';
import '../../services/firestore_crud.dart';

enum branch { CE, IT, ENTC }

enum gender { male, female, other }

class SignUp extends StatefulWidget {
  static const routeName = '/sign_up';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final Map<String, String> _userData = {
    'Name': '',
    'Branch': '',
    'DOB': '',
    'UID': '',
    'Phone': '',
    'Blood Group': '',
    'Gender': '',
    'ImageURL': '',
  };
  List<String> bloodgrp = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  branch? state;
  gender? gen;
  final TextEditingController _date = TextEditingController();
  var _dropVal = 'A+';
  final _key = GlobalKey<FormState>();
  File? _storedImage;
  String? _storedImageURL;
  // String? _fetchedImageURL;

  @override
  void dispose() {
    _date.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _key.currentState!.validate();
    if (!isValid) return;
    _key.currentState!.save();
    // print('FORM SAVED!!');
    // print(_userData);
    // await Firestore(path: 'users').post(_userData).then((value) {
    //   User.m = _userData;
    //   // print('DATA POSTED');
    //   Navigator.of(context).pop();
    // });
    await BlocProvider.of<AuthCubit>(context)
        .postUserDetails(
          _userData,
        )
        .then(
          (value) => Navigator.of(context).pop(),
        );
  }

  Future<void> _cameraImage() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (imageFile == null) return;
    setState(() {
      _storedImage = File(imageFile.path);
      _storedImageURL = base64UrlEncode(_storedImage!.readAsBytesSync());
      _userData['ImageURL'] = _storedImageURL ?? '';
    });
  }

  Future<void> _fileImage() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (imageFile == null) return;
    setState(() {
      _storedImage = File(imageFile.path);
      _storedImageURL = base64UrlEncode(_storedImage!.readAsBytesSync());
      _userData['ImageURL'] = _storedImageURL ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ENTER YOUR DETAILS'),
      ),
      body: Container(
        color: Colors.blue[100],
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(label: Text('Your Name')),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter you Name';
                    }
                    if (value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _userData['Name'] = newValue ?? '',
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(label: Text('Enter Reg.ID Number')),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null) return 'Please provide a value';
                    if (value.isEmpty) {
                      return 'Please enter a valid Reg.ID number';
                    }
                    value.toUpperCase();
                    if (!(value.startsWith('C') &&
                        value.length == 11 &&
                        value[2] == 'K')) {
                      return 'Please enter a valid Reg.ID number';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _userData['UID'] = newValue ?? '',
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your Branch',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      color: Colors.green[300],
                      child: const Text('CE'),
                    ),
                    Checkbox(
                        value: state == branch.CE ? true : false,
                        onChanged: (val) {
                          setState(() {
                            state = branch.CE;
                            _userData['Branch'] = 'CE';
                          });
                        }),
                    Container(
                      color: Colors.blue[400],
                      child: const Text('IT'),
                    ),
                    Checkbox(
                      value: state == branch.IT ? true : false,
                      onChanged: (val) {
                        setState(() {
                          state = branch.IT;
                          _userData['Branch'] = 'IT';
                        });
                      },
                    ),
                    Container(
                      color: Colors.purple[300],
                      child: const Text('ENTC'),
                    ),
                    Checkbox(
                      value: state == branch.ENTC ? true : false,
                      onChanged: (val) {
                        setState(() {
                          state = branch.ENTC;
                          _userData['Branch'] = 'ENTC';
                        });
                      },
                    )
                  ],
                ),
                TextField(
                  controller: _date,
                  decoration: const InputDecoration(
                    label: Text('Date of Birth'),
                    icon: Icon(Icons.calendar_month),
                  ),
                  onTap: () async {
                    DateTime? _pickedDOB = await showDatePicker(
                      initialDatePickerMode: DatePickerMode.day,
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (_pickedDOB != null) {
                      setState(() {
                        _date.text =
                            DateFormat('yyyy-MM-dd').format(_pickedDOB);
                        _userData['DOB'] = _date.text;
                      });
                    }
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(label: Text('Phone Number')),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a Phone number';
                    }
                    if (value.isEmpty) {
                      return 'Please enter a valid Phone number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid Phone number';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _userData['Phone'] = newValue!,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Male'),
                    Checkbox(
                      value: gen == gender.male,
                      onChanged: (_) {
                        setState(() {
                          gen = gender.male;
                          _userData['Gender'] = 'Male';
                        });
                      },
                    ),
                    const Text('Female'),
                    Checkbox(
                      value: gen == gender.female,
                      onChanged: (_) {
                        setState(() {
                          gen = gender.female;
                          _userData['Gender'] = 'Female';
                        });
                      },
                    ),
                    const Text('Other'),
                    Checkbox(
                      value: gen == gender.other,
                      onChanged: (_) {
                        setState(() {
                          gen = gender.other;
                          _userData['Gender'] = 'Other';
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.blue[100],
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    dropdownColor: Colors.blue[300],
                    elevation: 10,
                    value: _dropVal,
                    items: bloodgrp
                        .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                        .toList(),
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _dropVal = value;
                        _userData['Blood Group'] = value;
                      });
                    },
                  ),
                ),
                const Text(
                  'Enter an Image',
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.blue[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: _cameraImage,
                          icon: const Icon(Icons.camera)),
                      IconButton(
                          onPressed: _fileImage,
                          icon: const Icon(Icons.file_copy)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AnimatedContainer(
                  height: _storedImage == null ? 0 : 500,
                  width: _storedImage == null ? 0 : 500,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: _storedImage == null
                      ? null
                      : Image.file(File(_storedImage!.path)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 100, right: 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.9),
                  ),
                  child: TextButton(
                      onPressed: _saveForm, child: const Icon(Icons.done)),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: _storedImageURL == null ? 0 : 500,
                  width: _storedImageURL == null ? 0 : 500,
                  child: _storedImageURL == null
                      ? null
                      : Image.memory(base64Decode(_storedImageURL!)),
                ),
                // TEMP:
                // TextButton(
                //     onPressed: () async {
                //       final d = await Firestore.fetchID('C2K21107008');
                //       setState(() {
                //         _fetchedImageURL = d['ImageURL'];
                //       });
                //     },
                //     onLongPress: () => setState(() {
                //           _fetchedImageURL = null;
                //         }),
                //     child: Container(
                //         color: Colors.black,
                //         padding: const EdgeInsets.all(20),
                //         child: const Text('View Your Image')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
