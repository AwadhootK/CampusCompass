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
      await fetch();
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
      await fetch();
    } catch (error) {
      emit(AttendanceError(error: error.toString()));
    }
  }

  Future<void> fetch() async {
    emit(AttendanceLoading());
    try {
      final response = await cr1
          .doc(User.m!['UID'].toString().substring(0, 11))
          .collection('subjects')
          .get();

      List<Map<String, dynamic>> details = [];

      response.docs.forEach(
        (element) async {
          final date = await SharedPrefs.getCount(element.data()['name']);
          if (date.inDays >= 7) {
            var count = (date.inDays / 7).floor() *
                int.parse(element.data()['conductedWeekly']);
            dev.log(count.toString());
            element.data()['total'] = count;
            await incrementCount(element.data()['name'], count - 1, false);
          }
          details.insert(0, element.data());
        },
      );

      emit(AttendanceLoaded(details: details));
    } catch (error) {
      emit(AttendanceError(error: error.toString()));
    }
  }

  Future<void> incrementCount(String subject, int currentCount, bool c) async {
    try {
      emit(AttendanceLoading());
      await cr1
          .doc(User.m!['UID'].toString().substring(0, 11))
          .collection('subjects')
          .doc(subject)
          .update({c ? 'attended' : 'total': currentCount + 1});
      await fetch();
    } catch (e) {
      emit(AttendanceError(error: e.toString()));
    }
  }
}
