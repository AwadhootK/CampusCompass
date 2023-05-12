import 'package:bloc/bloc.dart';
import 'package:firebase/helpers/myException.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

part 'admin_states.dart';

class AdminAuthCubit extends Cubit<AdminAuthStates> {
  AdminAuthCubit() : super(AdminAuthInitialState());

  Future<void> _authenticateAdmin(
      String username, String password, String urlSegment) async {
    emit(AdminAuthLoadingState());
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBGEuqIMEaVcfM6GhCJZNE2gSgCWQnldho');
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': username,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final extractedData = json.decode(response.body);
      if (extractedData == null) throw 'Some error occurred...';
      if (extractedData['error'] != null) {
        throw httpException(extractedData['error']['message']);
      }
      emit(AdminAuthSuccessState());
    } catch (error) {
      // print('ERROR IS $error');
      log('_authenticate');
      log(error.toString());

      emit(AdminAuthErrorState(error.toString()));
    }
  }

  Future<void> signupAdmin(String username, String password) async {
    return _authenticateAdmin(username, password, 'signUp');
  }

  Future<void> loginAdmin(String username, String password) async {
    _authenticateAdmin(username, password, 'signInWithPassword');
  }

  void logout() {
    emit(AdminAuthLogoutState());
  }
}
