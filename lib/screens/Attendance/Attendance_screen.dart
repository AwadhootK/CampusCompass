import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/helpers/global_data.dart';
import 'package:firebase/screens/Attendance/logic/attendance_cubit.dart';
import 'package:firebase/screens/Attendance/pie_chart.dart';
import 'package:firebase/screens/Attendance/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';

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
      final nv = Navigator.of(context);
      await addSubject(details, details['name']);
      nv.pop();
    } catch (e) {
      log('Error saving data: $e');
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
      bloc: BlocProvider.of<AttendanceCubit>(context)..fetch(false),
      buildWhen: (previous, current) =>
          current is! IncrementUpdated && previous is! IncrementUpdated,
      builder: (context, state) {
        log(state.toString());
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
                const Center(
                    child: Text('No Subject Added for Attendance Tracking!'))
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
                right: 13,
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
              Positioned(
                bottom: 10,
                left: 13,
                child: FloatingActionButton(
                  onPressed: () {
                    Map<String, double> dataMap = {};
                    for (var i = 0; i < state.details!.length; i++) {
                      Map<String, dynamic> m = state.details![i];
                      dataMap[m['name']] =
                          double.parse(m['attended'].toString()) /
                              double.parse(m['total']);
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AttendancePieChart(dataMap: dataMap),
                      ),
                    );
                  },
                  child: const Icon(Icons.pie_chart),
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
