import 'package:flutter/material.dart';

class AuthProv extends ChangeNotifier {
  String? _userId;
  String? _jwt;
  Map<String, dynamic>? _userData;

  String? get userId => _userId;
  String? get jwt => _jwt;
  Map<String, dynamic>? get userData => _userData;

  set userId(String? id) {
    _userId = id;
    notifyListeners();
  }

  set jwt(String? token) {
    _jwt = token;
    notifyListeners();
  }

  set userData(Map<String, dynamic>? data) {
    _userData = data;
    notifyListeners();
  }

  void clearAuth() {
    _userId = null;
    _jwt = null;
    _userData = null;
    notifyListeners();
  }
}
