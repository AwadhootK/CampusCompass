import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'result_states.dart';

class ResultCubit extends Cubit<ResultState> {
  ResultCubit() : super(ResultLoading());

  Future<void> getUserData(String code) async {
    emit(ResultLoading());
    try {
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      DocumentSnapshot documentSnapshot =
          await firebaseFirestore.collection('users').doc(code).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        emit(ResultLoaded(data));
      } else {
        emit(ResultError('User not found'));
        return;
      }
    } catch (error) {
      emit(ResultError(error.toString()));
    }
  }
}
