part of 'admin_cubit.dart';

abstract class AdminAuthStates {}

class AdminAuthInitialState extends AdminAuthStates {}

class AdminAuthLoadingState extends AdminAuthStates {}

class AdminAuthErrorState extends AdminAuthStates {
  final String error;
  AdminAuthErrorState(this.error);
}

class AdminAuthSuccessState extends AdminAuthStates {}

class AdminPostedFoodItemState extends AdminAuthStates {}

class AdminAuthLogoutState extends AdminAuthStates {}