part of 'cart_cubit.dart';

abstract class CartState {}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoaded extends CartState {
  final List<FoodItem> items;

  CartLoaded(this.items);
}

class CartErrorState extends CartState {
  final String error;

  CartErrorState(this.error);
}

class UploadedState extends CartState {}