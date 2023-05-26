import 'dart:developer';

import 'package:CampusCompass/helpers/global_data.dart';
import 'package:CampusCompass/screens/Library/logic/library_cubit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import './libraryRecords.dart';
import '../logic/notifications_services.dart';
import 'package:timezone/timezone.dart' as tz;

class LibraryForm extends StatefulWidget {
  final Function addBook;

  LibraryForm(this.addBook);
  @override
  State<LibraryForm> createState() => _LibraryFormState();
}

class _LibraryFormState extends State<LibraryForm> {
  final NotificationScheduler _notificationScheduler = NotificationScheduler();
  final formKey = GlobalKey<FormState>();
  TextEditingController datecontrol = TextEditingController();
  TextEditingController datecontrol_return = TextEditingController();
  TextEditingController datecontrol_return2 = TextEditingController();
  TextEditingController time_control = TextEditingController();
  TextEditingController date_control = TextEditingController();
  // late LibraryDetails currentBook;
  Map<String, String> library = {
    'bookName': '',
    'issueDate': '',
    'returnDate': '',
  };
  late TimeOfDay selectedTime;
  late DateTime selectedDay;
  late DateTime returnDate;
  CollectionReference cr2 = FirebaseFirestore.instance.collection('library');
  List<Map<String, LibraryDetails>> m = [];

  Future<void> saveBookForm() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    formKey.currentState!.save();
    widget.addBook(
      library,
      timeOfDayToISOString(returnDate, selectedTime),
    );
  }

  String timeOfDayToISOString(DateTime selectedDay, TimeOfDay timeOfDay) {
    // final now = DateTime.now();
    final dateTime = DateTime(selectedDay.year, selectedDay.month,
        selectedDay.day, timeOfDay.hour, timeOfDay.minute);
    final formattedString = DateFormat('HH:mm:ss').format(dateTime);
    return '${selectedDay.toIso8601String().substring(0, 10)} $formattedString';
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
                    decoration: InputDecoration(
                      // hintText: widget.uid.toUpperCase().substring(0, 11),
                      labelText: 'Enter Book Name',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusColor: Colors.green,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: date_control,
                    // decoration: const InputDecoration(
                    //   labelText: 'Date of Birth',
                    //   prefixIcon: Icon(Icons.calendar_month),
                    // ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      labelText: 'Book Issue Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      fillColor: Colors.green,
                      focusColor: Colors.green,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                            2000,
                          ),
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = pickedDate.toIso8601String();
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          date_control.text =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          datecontrol.text = formattedDate;
                          library['issueDate'] = datecontrol
                              .text; //set output date to TextField value.
                        });
                      }
                    },
                  ),
                  // TextButton(
                  //   child: const Text("Issue Date"),
                  //   onPressed: () async {
                  //     DateTime? pickedDate = await showDatePicker(
                  //         context: context,
                  //         initialDate: DateTime.now(),
                  //         firstDate: DateTime(
                  //           2000,
                  //         ),
                  //         lastDate: DateTime(2101));

                  //     if (pickedDate != null) {
                  //       print(
                  //           pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  //       String formattedDate = pickedDate.toIso8601String();
                  //       print(
                  //           formattedDate); //formatted date output using intl package =>  2021-03-16
                  //       //you can implement different kind of Date Format here according to your requirement

                  //       setState(() {
                  //         datecontrol.text = formattedDate;
                  //         library['issueDate'] = datecontrol
                  //             .text; //set output date to TextField value.
                  //       });
                  //     }
                  //   },
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: datecontrol_return2,
                    // decoration: const InputDecoration(
                    //   labelText: 'Date of Birth',
                    //   prefixIcon: Icon(Icons.calendar_month),
                    // ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      labelText: 'Book Return Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusColor: Colors.green,
                      fillColor: Colors.green,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        log(pickedDate.toIso8601String());
                        String formattedDate = pickedDate.toIso8601String();
                        print(formattedDate);

                        returnDate = pickedDate;
                        setState(() {
                          datecontrol_return2.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          datecontrol_return.text = formattedDate;
                          library['returnDate'] = datecontrol_return.text;
                        });
                      }
                    },
                  ),
                  // OutlinedButton(
                  //   style: OutlinedButton.styleFrom(
                  //       side: BorderSide(color: Colors.green)),
                  //   child: const Text(
                  //     "Return Date",
                  //     style: TextStyle(color: Colors.green),
                  //   ),
                  //   onPressed: () async {
                  //     DateTime? pickedDate = await showDatePicker(
                  //       context: context,
                  //       initialDate: DateTime.now(),
                  //       firstDate: DateTime(2000),
                  //       lastDate: DateTime(2101),
                  //     );

                  //     if (pickedDate != null) {
                  //       log(pickedDate.toIso8601String());
                  //       String formattedDate = pickedDate.toIso8601String();
                  //       print(formattedDate);

                  //       returnDate = pickedDate;
                  //       setState(() {
                  //         datecontrol_return.text = formattedDate;
                  //         library['returnDate'] = datecontrol_return.text;
                  //       });
                  //     }
                  //   },
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green)),
                    onPressed: () async {
                      DateTime? pickedDay = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                            2000,
                          ),
                          lastDate: DateTime(2101));

                      if (pickedDay != null) {
                        log(pickedDay.toString());
                        String formattedTime = pickedDay.toIso8601String();
                        log(formattedTime);

                        selectedDay = pickedDay;
                        setState(() {
                          date_control.text = formattedTime;
                          library['date_control'] = date_control.text;
                        });
                      }
                    },
                    child: const Text(
                      "Choose Date for Reminder",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green)),
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        log(pickedTime.toString());
                        String formattedTime = pickedTime.toString();
                        log(formattedTime);
                        selectedTime = pickedTime;
                        setState(() {
                          time_control.text = formattedTime;
                          library['time_control'] = time_control.text;
                        });
                      }
                    },
                    child: const Text(
                      "Choose Time for Reminder",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      // log(timeOfDayToISOString(selectedTime));
                      DateTime dateTimeObj = DateFormat("yyyy-MM-dd")
                          .parse(library['returnDate']!);
                      String monthName = DateFormat('MMMM').format(
                          DateTime(dateTimeObj.year, dateTimeObj.month));
                      String weekdayName = DateFormat('EEEE').format(
                        DateTime(dateTimeObj.year, dateTimeObj.month,
                            dateTimeObj.weekday * 7),
                      );
                      String returnDate =
                          '${dateTimeObj.day} $monthName, $weekdayName';

                      saveBookForm();
                      _notificationScheduler.scheduleNotification(
                        'Book Return Reminder!',
                        'Your book ${library['bookName']} is due for return on $returnDate',
                        DateFormat('yyyy-MM-dd HH:mm:ss').parse(
                            timeOfDayToISOString(selectedDay, selectedTime)),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Add Book"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
