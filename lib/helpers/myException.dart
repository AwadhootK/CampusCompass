import 'package:flutter/material.dart';

class httpException {
  String _exp;
  httpException(this._exp);

  String get exception {
    return _exp.toString();
  }
}
