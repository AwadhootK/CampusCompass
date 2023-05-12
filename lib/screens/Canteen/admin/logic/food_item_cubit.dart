import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/Canteen/admin/models/food_item_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

part 'food_item_state.dart';

class FoodItemCubit extends Cubit<FoodItemState> {
  FoodItemCubit() : super(FoodItemInitialState());

  Future<void> postFoodItem(Map<String, dynamic> m, bool? isEditing) async {
    emit(FoodItemLoadingState());
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('daily items');
      if (isEditing == null) {
        await collectionReference.doc(m['name']!).set(m);
      } else {
        await collectionReference.doc(m['name']!).update(m);
      }
      emit(FoodItemSuccessState());
    } catch (error) {
      emit(FoodItemErrorState(error.toString()));
    }
  }

  Future<void> fetchFoodItems() async {
    emit(FoodItemLoadingState());
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('daily items');
      final response = await collectionReference.get();
      final List<QueryDocumentSnapshot> docs = response.docs;
      final List<FoodItem> items = [];

      docs.forEach((element) {
        items.add(FoodItem(
          name: element['name'],
          price: element['price'].toInt(),
          image: element['photo'],
          availability: element['availability'],
        ));
      });

      items.forEach((element) {
        log(element.name!);
        log(element.price!.toString());
        log(element.availability!.toString());
      });
      emit(FoodItemsFetchedState(items));
    } catch (error) {
      emit(FoodItemErrorState(error.toString()));
    }
  }

  Future<void> deleteFoodItem(String name) async {
    emit(FoodItemLoadingState());
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('daily items');
      await collectionReference.doc(name).delete();
      await fetchFoodItems();
    } catch (error) {
      emit(FoodItemErrorState(error.toString()));
    }
  }

  Future<void> updateFoodItemAvailability(Map<String, dynamic> m) async {
    emit(FoodItemLoadingState());
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('daily items');
      await collectionReference.doc(m['name']).update(m);
      await fetchFoodItems();
    } catch (error) {
      log(error.toString());
      emit(FoodItemErrorState(error.toString()));
    }
  }
}
