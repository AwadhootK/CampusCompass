import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatefulWidget {
  MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final _descriptionFocusNode = FocusNode();
    final _dateFocusNode = FocusNode();
    final _posterFocusNode = FocusNode();
    TextEditingController dateTime = TextEditingController();
    File? _storedImage;
    String? _storedImg;
    String? _fetchedImg;
    final _form = GlobalKey<FormState>();
    Map<String, String> map_1 = {
      'title': "",
      'date': "",
      'description': "",
      'poster': "",
    };

    @override
    void dispose() {
      _descriptionFocusNode.dispose();
      _dateFocusNode.dispose();
      _posterFocusNode.dispose();
      dateTime.dispose();
      super.dispose();
    }

    void _saveform() {
      // _form.currentState!.validate();
      print('called');
      _form.currentState!.save();
      print('form saved');
      print(map_1);
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
        _storedImg = base64UrlEncode(_storedImage!.readAsBytesSync());
        print(_storedImg);
        map_1['poster'] = _storedImg ?? '';
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
        _storedImg = base64UrlEncode(_storedImage!.readAsBytesSync());

        map_1['poster'] = _storedImg ?? "";
      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("POSTS FORM")),
        // backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
                child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "TITLE",
                  labelStyle: TextStyle(fontStyle: FontStyle.italic),
                ),
                keyboardType: TextInputType.text,
                // onFieldSubmitted: (_) {
                //   FocusScope.of(context).requestFocus(_dateFocusNode);
                // },
                onSaved: (value) {
                  map_1['title'] = value.toString();
                },
              ),
              // TextField(  //my code not working
              //   controller: dateTime,
              //   decoration: const InputDecoration(
              //     icon: Icon(
              //       Icons.calendar_today_rounded,
              //     ),
              //     labelText: "DATE",
              //     labelStyle: TextStyle(fontStyle: FontStyle.italic),
              //   ),
              //   // keyboardType: TextInputType.datetime,
              //   onTap: () async {
              //     print("hi");
              //     DateTime? picked = await showDatePicker(
              //         context: context,
              //         initialDate: new DateTime.now(),
              //         firstDate: new DateTime(1999),
              //         lastDate: new DateTime(2100));

              //     if (picked != null) {
              //       setState(() {
              //         dateTime.text = DateFormat('yyyy-MM-dd').format(picked);
              //       });
              //     }
              //     ;
              //     FocusScope.of(context).requestFocus(_descriptionFocusNode);

              //     map_1['date'] = dateTime.text;
              //   },
              //   focusNode: _dateFocusNode,
              // ),
              TextField(
                //awadhoot's code not working
                controller: dateTime,
                // focusNode: _dateFocusNode,
                decoration: const InputDecoration(
                  label: Text('Date of Event'),
                  icon: Icon(Icons.calendar_month),
                ),
                onTap: () async {
                  print("HERE");
                  DateTime? _picked = await showDatePicker(
                    initialDatePickerMode: DatePickerMode.day,
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (_picked != null) {
                    setState(() {
                      dateTime.text = DateFormat('yyyy-MM-dd').format(_picked);
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
                focusNode: _descriptionFocusNode,
                keyboardType: TextInputType.multiline,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_posterFocusNode);
                },
                onSaved: (value) {
                  map_1['description'] = value.toString();
                },
              ),

              // TextField(
              //     focusNode: _posterFocusNode,
              //     decoration: InputDecoration(
              //       label: Text('Enter an Image'),
              //     ),
              //     textAlign: TextAlign.left,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter an Image",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                color: Color.fromARGB(255, 152, 182, 207),
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
                color: Colors.blueAccent,
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
              const SizedBox(height: 20),
              IconButton(
                // ignore: sort_child_properties_last
                icon: const Icon(Icons.save),
                onPressed: () => _saveform(),
              ),
            ])),
          ),
        ),
      ),
    );
  }
}
