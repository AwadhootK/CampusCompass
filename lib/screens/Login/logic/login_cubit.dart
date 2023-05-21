import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';

import '../../../helpers/myException.dart';
import '../../../helpers/global_data.dart';
import '../../../services/firestore_crud.dart';

part 'login_state.dart';

class AuthCubit extends Cubit<LoginState> {
  AuthCubit() : super(LoginLoadingState());

  String? _token;
  DateTime? _expiryTime;
  String? _userID;
  Timer? _authTimer;

  String? get token {
    if (_expiryTime != null && DateTime.now().isBefore(_expiryTime!) ||
        _token != null) {
      return _token;
    }
  }

  Future<void> isAuth() async {
    try {
      if (token != null) {
        emit(LoginSuccessState());
        return;
      }
      emit(LoginFailedState());
    } catch (error) {
      log('isAuth');
      emit(LoginError(error.toString()));
    }
  }

  Future<void> _authenticate(
      String username, String password, String urlSegment) async {
    emit(LoginLoadingState());
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

      _userID = extractedData['localId'];
      _token = extractedData['idToken'];
      _expiryTime = DateTime.now()
          .add(Duration(seconds: int.parse(extractedData['expiresIn'])));
      autoLogOut();
      if (urlSegment == 'signUp') {
        emit(LoginSuccessState());
      }
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'userData',
          json.encode({
            'token': _token,
            'userID': _userID,
            'username': username.substring(0, 11),
            'expiryTime': _expiryTime!.toIso8601String()
          }));
      if (urlSegment == 'signInWithPassword') {
        // print('USER DATA');
        // User.m = await Firestore.fetchID(username.substring(0, 11));
        // print(User.m);
      }
    } catch (error) {
      // print('ERROR IS $error');
      log('_authenticate');
      log(error.toString());

      User.m =
          null; // to prevent storing the user's data unnecessarily if authentication failed
      emit(LoginError(error.toString()));
      rethrow;
    }
  }

  Future<void> postUserDetails(Map<String, String> m) async {
    emit(LoginLoadingState());
    try {
      CollectionReference cr1 = FirebaseFirestore.instance.collection('users');
      await cr1.doc(m['UID']).set(m);
      User.m = m;
      emit(UserDataPosted(m));
    } catch (error) {
      log('postUserDetails');
      emit(LoginError(error.toString()));
    }
  }

  Future<void> signup(String username, String password) async {
    try {

    await _authenticate(username, password, 'signUp');
    emit(SignUpSuccessful(username));
    } catch(e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> login(String username, String password) async {
    _authenticate(username, password, 'signInWithPassword').then(
      (_) async {
        User.m =
            await Firestore(path: 'users').fetchID(username.substring(0, 11));
      },
    ).then(
      (_) async {
        await Firestore(path: 'clubs').fetchClubID();
      },
    ).then((_) {
      emit(LoginSuccessState());
      return;
    });
  }

  Future<void> logout() async {
    emit(LoginLoadingState());

    try {
      User.m = null;
      _token = null;
      _userID = null;
      _expiryTime = null;
      if (_authTimer != null) {
        _authTimer!.cancel();
        _authTimer = null;
      }

      emit(LogOutState());
      // clear data stored in the device
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('userData'); // only removes the particular key-value pair
      // prefs.clear();     // clears all the stored data
    } catch (error) {
      log('logout');
      emit(LoginError(error.toString()));
    }
  }

  Future<void> tryAutoLogin() async {
    emit(TryLoginLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();

      // no preferences found -> login unsuccessful
      if (!prefs.containsKey('userData')) {
        emit(TryLoginFailedState());
        return;
      }

      final extractedData = json.decode(prefs.getString('userData') ?? '')
          as Map<String, dynamic>;
      final expiryData = DateTime.parse(extractedData['expiryTime']);

      // preferences found but the token has expired -> login unsuccessful
      if (expiryData.isBefore(DateTime.now())) {
        emit(TryLoginFailedState());
        return;
      }

      // token is valid -> login successful
      await Future.delayed(
        const Duration(seconds: 3),
      ); // just to show the splash screen for 3 sec

      log('tryAutoLogin SUCCESS');

      _userID = extractedData['userID'];
      _token = extractedData['token'];
      _expiryTime = DateTime.parse(extractedData['expiryTime']);

      User.m = await Firestore(path: 'users')
          .fetchID(extractedData['username'].substring(0, 11));

      // log(User.m.toString());

      Firestore(path: 'clubs')
          .fetchClubID()
          .then((value) => log(User.clubs.toString()));
      autoLogOut();

      emit(TryLoginSuccessState());
    } catch (error) {
      log('tryAutoLogin');
      emit(TryLoginError(error.toString()));
    }
  }

  void autoLogOut() {
    try {
      if (_authTimer != null) {
        _authTimer!.cancel();
      }
      _authTimer = Timer(
          Duration(seconds: _expiryTime!.difference(DateTime.now()).inSeconds),
          logout);
    } catch (error) {
      log('autoLogout');
      emit(LoginError(error.toString()));
    }
  }

  void emitError(String e) {
    emit(LoginError(e));
  }
}
