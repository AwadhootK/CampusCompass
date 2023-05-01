import 'package:bloc/bloc.dart';
import 'dart:developer';

part 'bottomnavbar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavProfile());

  int _index = 0;

  int get bottonNavBarIndex => _index;

  void changeIndex(int index) {
    _index = index;
    log('_index changed to $_index');
    if (_index == 0) {
      emit(BottomNavProfile());
    } else if (_index == 1) {
      emit(BottomNavClubs());
    } else if (_index == 2) {
      emit(BottomNavLibrary());
    } else if (_index == 3) {
      emit(BottomNavAttendance());
    } else {
      emit(BottomNavProfile());
    }
  }
}
