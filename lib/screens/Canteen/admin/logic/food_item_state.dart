part of 'food_item_cubit.dart';

abstract class FoodItemState {}

class FoodItemInitialState extends FoodItemState {}

class FoodItemLoadingState extends FoodItemState {}

class FoodItemErrorState extends FoodItemState {
  final String error;
  FoodItemErrorState(this.error);
}

class FoodItemSuccessState extends FoodItemState {}

class FoodItemsFetchedState extends FoodItemState {
  final List<FoodItem> items;
  FoodItemsFetchedState(this.items);
}

class RefetchDataState extends FoodItemState {}