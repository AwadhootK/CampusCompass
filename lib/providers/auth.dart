import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import '../helpers/myException.dart';
import '../helpers/global_data.dart';
import '../services/firestore_crud.dart';

class Auth with ChangeNotifier {
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

  bool isAuth() {
    if (token != null) return true;
    return false;
  }

  Future<void> _authenticate(
      String username, String password, String urlSegment) async {
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
      notifyListeners();
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
        print('USER DATA');
        User.m = await Firestore.fetchID(username.substring(0, 11));
        print(User.m);
      }
    } catch (error) {
      print('ERROR IS $error');
      rethrow;
    }
  }

  Future<void> signup(String username, String password) async {
    return _authenticate(username, password, 'signUp');
  }

  Future<void> login(String username, String password) async {
    return _authenticate(username, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userID = null;
    _expiryTime = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();

    // clear data stored in the device
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData'); // only removes the particular key-value pair
    // prefs.clear();     // clears all the stored data
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    // no preferences found -> login unsuccessful
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedData =
        json.decode(prefs.getString('userData') ?? '') as Map<String, dynamic>;
    final expiryData = DateTime.parse(extractedData['expiryTime']);

    // preferences found but the token has expired -> login unsuccessful
    if (expiryData.isBefore(DateTime.now())) {
      return false;
    }

    // token is valid -> login successful
    await Future.delayed(
      const Duration(seconds: 3),
    ); // just to show the splash screen for 5 sec

    _userID = extractedData['userID'];
    _token = extractedData['token'];
    _expiryTime = DateTime.parse(extractedData['expiryTime']);
    User.m =
        await Firestore.fetchID(extractedData['username'].substring(0, 11));

    autoLogOut();
    notifyListeners();
    return true;
  }

  void autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    _authTimer = Timer(
        Duration(seconds: _expiryTime!.difference(DateTime.now()).inSeconds),
        logout);
  }
}
