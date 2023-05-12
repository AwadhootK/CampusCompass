part of 'login_cubit.dart';

abstract class LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState(this.error);
}

class LoginSuccessState extends LoginState {}

class LoginFailedState extends LoginState {}

class LogOutState extends LoginState {}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}

class SignUpSuccessful extends LoginState {}

class UserDataPosted extends LoginState {
  final Map<String, String> userData;
  UserDataPosted(this.userData);
}

class AdminSuccessState extends LoginState {}