part of 'result_cubit.dart';

abstract class ResultState {}

class ResultLoading extends ResultState {}

class ResultLoaded extends ResultState {
  final Map<String, dynamic> result;
  ResultLoaded(this.result);
}

class ResultError extends ResultState {
  final String message;
  ResultError(this.message);
}
