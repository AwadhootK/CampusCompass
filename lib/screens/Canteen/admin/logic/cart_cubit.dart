import 'package:firebase/screens/Canteen/admin/models/food_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/Canteen/admin/models/food_item_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

part 'cart_states.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitialState());

  Future<void> getCartItems(String UID, List<FoodItem> l) async {
    log('CALLED');
    emit(CartLoadingState());
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('cart');
      final List<FoodItem> items = [];
      final response = await collectionReference.doc(UID).get()
        ..data();
      if (!response.exists) {
        await collectionReference.doc(UID).set({'cartItems': []});
        emit(CartLoaded(items));
        return;
      }
      log(response.toString());
      response['cartItems'].forEach((element) {
        items.add(FoodItem(
          name: element,
          price: l
              .firstWhere((e) =>
                  e.name!.toLowerCase() == element.toString().toLowerCase())
              .price!
              .toInt(),
          image: l
              .firstWhere((e) =>
                  e.name!.toLowerCase() == element.toString().toLowerCase())
              .image,
        ));
      });
      log(items.toString());
      emit(CartLoaded(items));
    } catch (error) {
      emit(CartErrorState(error.toString()));
    }
  }

  Future<void> addtoCart(String name, String UID) async {
    emit(CartLoadingState());
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('cart');
      await collectionReference.doc(UID).update({
        'cartItems': FieldValue.arrayUnion([name])
      });
      emit(UploadedState());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeFromCart(String name, String UID) async {
    // emit(CartLoadingState());
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('cart');
      await collectionReference.doc(UID).update({
        'cartItems': FieldValue.arrayRemove([name])
      });
      // emit(UploadedState());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> payAndCheckOut() async {}
}
