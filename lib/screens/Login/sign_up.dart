import 'dart:convert';

import 'package:firebase/screens/Login/logic/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum Branch { CE, IT, ENTC }

enum Gender { male, female, other }

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
  List<String> bloodGroups = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  Branch? selectedBranch;
  Gender? selectedGender;
  final TextEditingController _date = TextEditingController();
  var _dropVal = 'A+';
  final _formKey = GlobalKey<FormState>();
  File? _storedImage;
  String? _storedImageURL;

  @override
  void dispose() {
    _date.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    await BlocProvider.of<AuthCubit>(context).postUserDetails(_userData);
    // .then((value) => Navigator.of(context).pop());
  }

  Future<void> _pickImage(ImageSource source) async {
    final imageFile = await ImagePicker().pickImage(
      source: source,
      maxHeight: 200,
      maxWidth: 200,
      imageQuality: 100,
    );
    if (imageFile == null) return;
    setState(() {
      _storedImage = File(imageFile.path);
      _storedImageURL = base64UrlEncode(_storedImage!.readAsBytesSync());
      _userData['ImageURL'] = _storedImageURL ?? '';
    });
  }

  Future<void> _cameraImage() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 200,
      maxWidth: 200,
      imageQuality: 100,
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
        automaticallyImplyLeading: false,
        title: const Text('Enter Your Details'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue[100],
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // decoration: const InputDecoration(labelText: 'Your Name'),
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    focusColor: Colors.blue,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter your Name';
                    }
                    if (value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _userData['Name'] = newValue ?? '',
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // decoration: const InputDecoration(labelText: 'Reg.ID Number'),
                  decoration: const InputDecoration(
                    labelText: 'Reg. ID No.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    focusColor: Colors.blue,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null) return 'Please provide a value';
                    if (value.isEmpty) {
                      return 'Please enter a valid Reg.ID number';
                    }
                    value.toUpperCase();
                    if (!((value.startsWith('C') ||
                            value.startsWith('I') ||
                            value.startsWith('E')) &&
                        value.length == 11 &&
                        value[2] == 'K')) {
                      return 'Please enter a valid Reg.ID number';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _userData['UID'] = newValue ?? '',
                ),
                const SizedBox(height: 15),
                const Divider(
                  color: Colors.blue,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Your Branch',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(
                  color: Colors.blue,
                ),
                // const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBranch = Branch.CE;
                          _userData['Branch'] = 'CE';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedBranch == Branch.CE
                            ? Colors.green[300]
                            : null,
                      ),
                      child: const Text('CE'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBranch = Branch.IT;
                          _userData['Branch'] = 'IT';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedBranch == Branch.IT
                            ? Colors.blue[400]
                            : null,
                      ),
                      child: const Text('IT'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBranch = Branch.ENTC;
                          _userData['Branch'] = 'ENTC';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedBranch == Branch.ENTC
                            ? Colors.purple[300]
                            : null,
                      ),
                      child: const Text('ENTC'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: _date,
                  // decoration: const InputDecoration(
                  //   labelText: 'Date of Birth',
                  //   prefixIcon: Icon(Icons.calendar_month),
                  // ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month),
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    focusColor: Colors.blue,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  onTap: () async {
                    DateTime? pickedDOB = await showDatePicker(
                      initialDatePickerMode: DatePickerMode.day,
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDOB != null) {
                      setState(() {
                        _date.text = DateFormat('yyyy-MM-dd').format(pickedDOB);
                        _userData['DOB'] = _date.text;
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // decoration: const InputDecoration(labelText: 'Phone Number'),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month),
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    focusColor: Colors.blue,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
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
                const SizedBox(height: 20),
                const Divider(
                  color: Colors.blue,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Your Gender',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(
                  color: Colors.blue,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Male'),
                    Checkbox(
                      value: selectedGender == Gender.male,
                      onChanged: (val) {
                        setState(() {
                          selectedGender = Gender.male;
                          _userData['Gender'] = 'Male';
                        });
                      },
                    ),
                    const Text('Female'),
                    Checkbox(
                      value: selectedGender == Gender.female,
                      onChanged: (val) {
                        setState(() {
                          selectedGender = Gender.female;
                          _userData['Gender'] = 'Female';
                        });
                      },
                    ),
                    const Text('Other'),
                    Checkbox(
                      value: selectedGender == Gender.other,
                      onChanged: (val) {
                        setState(() {
                          selectedGender = Gender.other;
                          _userData['Gender'] = 'Other';
                        });
                      },
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.blue,
                ),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Blood Group',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),

                Container(
                  // padding: const EdgeInsets.all(10),
                  color: Colors.blue[200],
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    iconEnabledColor: Colors.blue[800],
                    dropdownColor: Colors.blue[400],
                    elevation: 10,
                    value: _dropVal,
                    items: bloodGroups
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
                const SizedBox(height: 15),
                const Divider(
                  color: Colors.blue,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter Your Image',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),

                Container(
                  color: Colors.blue[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: _cameraImage,
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'Open Camera',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 20,
                        color: Colors.blue[100],
                      ),
                      TextButton(
                          onPressed: _fileImage,
                          child: Row(
                            children: [
                              Icon(
                                Icons.file_copy,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                'Open Gallery',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          )),
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
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.9),
                  ),
                  child: TextButton(
                    onPressed: _saveForm,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
