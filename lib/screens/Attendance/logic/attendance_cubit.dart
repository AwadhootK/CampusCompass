import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/helpers/global_data.dart';
import 'package:firebase/screens/Attendance/logic/shared_prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'attendance_state.dart';

class AttendanceCubit extends Cubit<Attendance> {
  late CollectionReference cr1;

  AttendanceCubit() : super(AttendanceInitial()) {
    cr1 = FirebaseFirestore.instance.collection('attendance');
  }

  Future<void> postRecord(
      Map<String, dynamic> details, String _subjects) async {
    emit(AttendanceLoading());
    try {
      await cr1
          .doc(User.m!['UID'].toString().substring(0, 11))
          .collection('subjects')
          .doc(_subjects)
          .set(details);
      // emit(AttendancePosted());
      await SharedPrefs.saveCount(_subjects, DateTime.now());
      await fetch(false);
    } catch (error) {
      emit(AttendanceError(error: error.toString()));
    }
  }

  Future<void> deleteSubject(String subject) async {
    emit(AttendanceLoading());
    try {
      await cr1
          .doc(User.m!['UID'].toString().substring(0, 11))
          .collection('subjects')
          .doc(subject)
          .delete();
      await SharedPrefs.deleteSP(subject);
      await fetch(false);
    } catch (error) {
      emit(AttendanceError(error: error.toString()));
    }
  }

  Future<void> fetch(bool val) async {
    if (val) emit(AttendanceLoading());
    try {
      final response = await cr1
          .doc(User.m!['UID'].toString().substring(0, 11))
          .collection('subjects')
          .get();

      List<Map<String, dynamic>> details = [];

      for (var element in response.docs) {
        final date = await SharedPrefs.getCount(element.data()['name']);
        Map<String, dynamic> newElement = element.data();
        if (date.inDays >= 7 && !val) {
          var count = (date.inMinutes / 7).floor() *
              int.parse(element.data()['conductedWeekly']);
          newElement['total'] = count;
          await incrementCount(newElement['name'], count - 1, false);
        }
        details.insert(0, newElement);
      }
      if (val) {
        emit(IncrementUpdated());
        return;
      }
      emit(AttendanceLoaded(details: details));
    } catch (error) {
      emit(AttendanceError(error: error.toString()));
    }
  }

  Future<void> incrementCount(String subject, int currentCount, bool c) async {
    try {
      // emit(AttendanceLoading());
      await cr1
          .doc(User.m!['UID'].toString().substring(0, 11))
          .collection('subjects')
          .doc(subject)
          .update({c ? 'attended' : 'total': currentCount + 1});
      await fetch(false);
    } catch (e) {
      emit(AttendanceError(error: e.toString()));
    }
  }
}
