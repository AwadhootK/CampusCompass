import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase/screens/Clubs/logic/clubs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ClubsForm extends StatefulWidget {
  static const routeName = '/clubs_form';
  final bool isEditing;
  final Map<String, String> eventDetails;

  ClubsForm({
    this.isEditing = false,
    this.eventDetails = const {},
  });

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
    'originalName': '',
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
    if (widget.isEditing) {
      log(widget.eventDetails.toString());
      BlocProvider.of<ClubsCubit>(context)
          .editEvent(
        widget.eventDetails,
      )
          .then((value) async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        await BlocProvider.of<ClubsCubit>(context).fetchClubEvents();
      });
      return;
    }
    BlocProvider.of<ClubsCubit>(context).putEvent(map_1).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      BlocProvider.of<ClubsCubit>(context).fetchClubEvents();
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
      if (widget.isEditing) {
        widget.eventDetails['poster'] = storedImg ?? map_1['poster'] ?? '';
      } else {
        map_1['poster'] = storedImg ?? '';
      }
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
      // map_1['poster'] = storedImg ?? '';
      if (widget.isEditing) {
        widget.eventDetails['poster'] = storedImg ?? map_1['poster'] ?? '';
      } else {
        map_1['poster'] = storedImg ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log(widget.eventDetails.toString());
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('Enter Event Details'),
        centerTitle: true,
      ),
      // backgroundColor: Colors.black,
      body: BlocConsumer<ClubsCubit, ClubStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ClubsErrorState) {
            return const Center(child: Text('Error'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: widget.isEditing
                              ? widget.eventDetails['title']
                              : 'Enter Title',
                          labelStyle: TextStyle(
                            color: widget.isEditing
                                ? Colors.grey[600]
                                : Colors.blue,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusColor: Colors.blue,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null) return 'Please enter a value';
                          return null;
                        },
                        onSaved: (value) {
                          if (widget.isEditing) {
                            if (value == '' || value == null) {
                              return;
                            }
                            widget.eventDetails['title'] = value.toString();
                            return;
                          }
                          map_1['title'] = value.toString();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: dateTime,
                        decoration: InputDecoration(
                          labelText: widget.isEditing
                              ? widget.eventDetails['date']
                              : 'Enter Date',
                          labelStyle: TextStyle(
                            color: widget.isEditing
                                ? Colors.grey[600]
                                : Colors.blue,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusColor: Colors.blue,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
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
                              if (widget.isEditing) {
                                widget.eventDetails['date'] = dateTime.text;
                              } else {
                                map_1['date'] = dateTime.text;
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: widget.isEditing
                              ? widget.eventDetails['description']
                              : 'Enter Description',
                          labelStyle: TextStyle(
                            color: widget.isEditing
                                ? Colors.grey[600]
                                : Colors.blue,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusColor: Colors.blue,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
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
                          if (widget.isEditing) {
                            if (value == '' || value == null) {
                              return;
                            }
                            widget.eventDetails['description'] =
                                value.toString();
                            return;
                          }
                          map_1['description'] = value.toString();
                        },
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
                      if (widget.isEditing && storedImage == null)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          child: Image.memory(
                            base64Decode(widget.eventDetails['poster']!),
                            fit: BoxFit.cover,
                          ),
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
                      ElevatedButton(
                        child: const Text('Submit'),
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
