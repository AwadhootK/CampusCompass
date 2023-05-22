import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/helpers/global_data.dart';
import 'package:firebase/screens/Attendance/logic/attendance_cubit.dart';
import 'package:firebase/screens/Attendance/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAttendanceForm extends StatelessWidget {
  final Function addSubject;
  final BuildContext context;
  MyAttendanceForm({required this.addSubject, required this.context});

  static final _formKey = GlobalKey<FormState>();
  int _numberOfSubjects = 0;
  String _subjects = "";
  Map<String, dynamic> details = {
    'attended': 0,
    'conductedWeekly': 0,
    'name': "",
    'total': 0
  };

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    try {
      await addSubject(details, details['name']);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Subject Name',
              ),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a subject name';
                }
                return null;
              },
              onSaved: (value) {
                details['name'] = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Number of lectures conducted per week',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a number';
                }
                return null;
              },
              onSaved: (value) {
                details['conductedWeekly'] = value!;
                details['total'] = value;
              },
            ),
            ElevatedButton(
              onPressed: () => _saveForm(),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendanceCubit, Attendance>(
      bloc: BlocProvider.of<AttendanceCubit>(context)..fetch(),
      builder: (context, state) {
        if (state is AttendanceLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AttendanceLoaded) {
          if (state.details == null) {
            return Container();
          }
          log(state.details.toString());
          return Stack(
            children: [
              if (state.details!.isEmpty)
                Center(child: Text('No Subject Added for Attendance Tracking!'))
              else
                ListView.builder(
                  itemCount: state.details == null ? 0 : state.details!.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> m = state.details![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SubjectCard(
                        subjectName: m['name'],
                        attendedLectures: m['attended'],
                        totalLectures: int.parse(m['total']),
                        deleteSubject: BlocProvider.of<AttendanceCubit>(context)
                            .deleteSubject,
                        incrementCount:
                            BlocProvider.of<AttendanceCubit>(context)
                                .incrementCount,
                      ),
                    );
                  },
                ),
              Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => MyAttendanceForm(
                        addSubject: BlocProvider.of<AttendanceCubit>(context)
                            .postRecord,
                        context: context,
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        } else if (state is AttendanceError) {
          return Center(
            child: Text(state.error),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      listener: (context, state) {},
    );
  }
}
