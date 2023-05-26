import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:CampusCompass/screens/Canteen/admin/models/food_item_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

part 'daily_item_states.dart';

class DailyItemCubit extends Cubit<DailyItemState> {
  DailyItemCubit() : super(DailyItemInitialState());

  Future<void> getDailyMenu() async {
    emit(DailyItemLoadingState());
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('meals');
      var response = await collectionReference.doc('Weekly meal').get()
        ..data();
      emit(DailyMenuLoadedState(response['image']));
    } catch (error) {
      log(error.toString());
      emit(DailyMenuLoadedState(error.toString()));
    }
  }
}
