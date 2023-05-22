part of 'attendance_cubit.dart';

abstract class Attendance {}

class AttendanceInitial extends Attendance {}

class AttendanceLoading extends Attendance {}

class AttendanceLoaded extends Attendance {
  List<Map<String, dynamic>>? details;
  AttendanceLoaded({required this.details});
}

class AttendanceError extends Attendance {
  String error;
  AttendanceError({required this.error});
}

class AttendancePosted extends Attendance {}
