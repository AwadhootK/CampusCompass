import 'dart:developer';
import 'dart:math';
import 'package:firebase/helpers/global_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../services/firestore_crud.dart';
import '../library/libraryRecords.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../notificationservices.dart';
import 'package:timezone/timezone.dart' as tz;

class LibraryForm extends StatefulWidget {
  @override
  State<LibraryForm> createState() => _LibraryFormState();
}

class _LibraryFormState extends State<LibraryForm> {
  final NotificationScheduler _notificationScheduler = NotificationScheduler();
  final formKey = GlobalKey<FormState>();
  TextEditingController datecontrol = TextEditingController();
  TextEditingController datecontrol_return = TextEditingController();
  TextEditingController time_control = TextEditingController();
  // late LibraryDetails currentBook;
  Map<String, String> library = {
    'bookName': '',
    'issueDate': '',
    'returnDate': '',
  };
  CollectionReference cr2 = FirebaseFirestore.instance.collection('library');

  List<Map<String, LibraryDetails>> m = [];

  Future<void> addbook(var x) async {
    await cr2.doc(x!.toString().substring(0, 11)).set(m);
  }

  void deleteBook(LibraryDetails booktoBeDeleted, var x) {
    m.forEach((element) {
      if (booktoBeDeleted.bookName == element['bookName']) {
        m.remove(element);
      }
      cr2.doc(x!.toString().substring(0, 11)).delete();
      addbook(x);
    });
  }

  Future<void> saveBookForm() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    formKey.currentState!.save();
    // m.add({currentBook.bookName: currentBook});
    //add to firestore

    // log(library.toString());
    // log(User.m!['UID'].toString().substring(0, 11));

    await cr2.doc(User.m!['UID'].toString().substring(0, 11)).set(library);
    // log('added');
    // await Firestore(path: 'library').putEvent().then((value) {
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      label: Text("Book Name"),
                      labelStyle: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    onSaved: (newValue) {
                      library['bookName'] = newValue ?? '';
                    },
                    validator: (value) {
                      if (value == null) return 'Please enter a value';
                      // currentBook.bookName = value;
                      return null;
                    },
                  ),
                  TextButton(
                    child: Text("Issue Date"),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          datecontrol.text = formattedDate;
                          library['issueDate'] = datecontrol
                              .text; //set output date to TextField value.
                        });
                      }
                    },
                  ),
                  TextButton(
                    child: Text("Return Date"),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = pickedDate.toIso8601String();
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          datecontrol_return.text = formattedDate;
                          library['returnDate'] = datecontrol_return.text;
                        });
                      }
                    },
                  ),
                  TextButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (pickedTime != null) {
                          print(
                              pickedTime); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedTime = pickedTime.toString();
                          print(
                              formattedTime); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            time_control.text = formattedTime;
                            library['time_control'] = time_control.text;
                          });
                        }
                      },
                      child: Text("Choose Time")),

                  //show time picker and read time to push notification

                  // Schedule notification for May 19, 2023, at 10:00 AM
                  ElevatedButton(
                    child: Text("Send Notification"),
                    onPressed: () {
                      _notificationScheduler.scheduleNotification(
                        DateFormat('yyyy-MM-dd HH:mm:ss')
                            .parse('2023-5-21 16:01:00'),
                      );
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        saveBookForm();
                        Navigator.pop(context);
                      },
                      child: Text("ADD BOOK")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
