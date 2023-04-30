import 'dart:convert';
import 'dart:io';

import 'package:firebase/screens/Clubs/logic/clubs_cubit.dart';
import 'package:firebase/screens/Clubs/ui/clubs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ClubsForm extends StatefulWidget {
  static const routeName = '/clubs_form';

  @override
  State<ClubsForm> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ClubsForm> {
  final descriptionFocusNode = FocusNode();
  final dateFocusNode = FocusNode();
  final posterFocusNode = FocusNode();
  TextEditingController dateTime = TextEditingController();
  File? storedImage;
  String? storedImg;
  final formkey = GlobalKey<FormState>();
  Map<String, String> map_1 = {
    'title': "",
    'date': "",
    'description': "",
    'poster': "",
    'club': "",
  };

  @override
  void dispose() {
    descriptionFocusNode.dispose();
    dateFocusNode.dispose();
    posterFocusNode.dispose();
    dateTime.dispose();
    super.dispose();
  }

  Future<void> _saveform() async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) return;
    formkey.currentState!.save();
    map_1['club'] = ModalRoute.of(context)!.settings.arguments as String;
    BlocProvider.of<ClubsCubit>(context).putEvent(map_1).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  Future<void> _cameraImage() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (imageFile == null) return;
    setState(() {
      storedImage = File(imageFile.path);
      storedImg = base64UrlEncode(storedImage!.readAsBytesSync());
      map_1['poster'] = storedImg ?? '';
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
      storedImage = File(imageFile.path);
      storedImg = base64UrlEncode(storedImage!.readAsBytesSync());
      map_1['poster'] = storedImg ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("POSTS FORM")),
      // backgroundColor: Colors.black,
      body: BlocConsumer<ClubsCubit, ClubStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ClubLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ClubsErrorState) {
            return const Center(child: Text('Error'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text("TITLE"),
                          labelStyle: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null) return 'Please enter a value';
                          return null;
                        },
                        onSaved: (value) {
                          map_1['title'] = value.toString();
                        },
                      ),
                      TextField(
                        controller: dateTime,
                        decoration: const InputDecoration(
                          label: Text('Date of Event'),
                          icon: Icon(Icons.calendar_month),
                        ),
                        onTap: () async {
                          DateTime? _picked = await showDatePicker(
                            initialDatePickerMode: DatePickerMode.day,
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (_picked != null) {
                            setState(() {
                              dateTime.text =
                                  DateFormat('yyyy-MM-dd').format(_picked);
                              map_1['date'] = dateTime.text;
                            });
                          }
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "DESCRIPTION",
                          labelStyle: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        focusNode: descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(posterFocusNode);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please provide a description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          map_1['description'] = value.toString();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter an Image",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 152, 182, 207),
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
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        height: storedImage == null ? 0 : 300,
                        width: storedImage == null ? 0 : 300,
                        child: storedImage == null
                            ? null
                            : Image.memory(base64Decode(storedImg!)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        // ignore: sort_child_properties_last
                        icon: const Icon(Icons.save),
                        onPressed: () => _saveform(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
