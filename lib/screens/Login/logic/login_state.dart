part of 'login_cubit.dart';

abstract class LoginState {}

class LoginLoadingState extends LoginState {}

class TryLoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState(this.error);
}

class LoginSuccessState extends LoginState {}

class TryLoginSuccessState extends LoginState {}

class LoginFailedState extends LoginState {}

class TryLoginFailedState extends LoginState {}

class LogOutState extends LoginState {}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}

class TryLoginError extends LoginState {
  final String error;
  TryLoginError(this.error);
}

class SignUpSuccessful extends LoginState {
  String uid;
  SignUpSuccessful(this.uid);
}

class UserDataPosted extends LoginState {
  final Map<String, String> userData;
  UserDataPosted(this.userData);
}

class AdminSuccessState extends LoginState {}
