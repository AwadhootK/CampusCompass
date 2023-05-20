import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'admin_states.dart';

class AdminAuthCubit extends Cubit<AdminAuthStates> {
  AdminAuthCubit() : super(AdminAuthInitialState());

  Future<void> authenticateAdmin(String code) async {
    emit(AdminAuthLoadingState());
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('users');

      final adminData = await collectionReference.doc('admin').get();
      if (adminData['code'] != code) {
        emit(AdminAuthErrorState('Invalid Admin Code'));
      }
      emit(AdminAuthSuccessState());
    } catch (error) {
      emit(AdminAuthErrorState(error.toString()));
    }
  }

  void logout() {
    emit(AdminAuthLogoutState());
  }
}
