part of 'daily_item_cubit.dart';

abstract class DailyItemState {}

class DailyItemInitialState extends DailyItemState {}

class DailyItemLoadingState extends DailyItemState {}

class DailyItemErrorState extends DailyItemState {
  final String error;
  DailyItemErrorState(this.error);
}

class DailyMenuLoadedState extends DailyItemState {
  final String img;
  DailyMenuLoadedState(this.img);
}