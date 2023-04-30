import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/helpers/global_data.dart';
import 'package:firebase/services/firestore_crud.dart';
part 'clubs_states.dart';

class ClubsCubit extends Cubit<ClubStates> {
  late CollectionReference cr1;
  ClubsCubit() : super(ClubLoadingState()) {
    cr1 = FirebaseFirestore.instance.collection('clubs');
  }

  Future<void> fetchClubEvents() async {
    emit(ClubLoadingState());
    try {
      User.events.forEach(
        (key, _) async {
          var snapshot = await cr1.doc(key).collection('posts').get();
          Map<String, Map<String, String>> event = {};
          for (int i = 0; i < snapshot.docs.length; i++) {
            event[snapshot.docs[i]['title']] = snapshot.docs[i].data().map(
                  (eventkey, eventvalue) => MapEntry(
                    eventkey.toString(),
                    eventvalue.toString(),
                  ),
                );
          }
          User.events.update(key, (val) => event);
        },
      );
      log('events fetched');
      emit(ClubsLoadedState(User.events));
    } catch (error) {
      emit(ClubsErrorState(error.toString()));
    }
  }

  Future<void> putEvent(Map<String, String> event) async {
    emit(ClubLoadingState());
    try {
      cr1
          .doc(event['club'])
          .collection('posts')
          .doc(event['title']!)
          .set(event);
      // .then((value) async => await fetchClubEvents());
    } catch (error) {
      emit(ClubsErrorState(error.toString()));
    }
  }
}
