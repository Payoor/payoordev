import 'package:flutter/material.dart';

class AuthProv extends ChangeNotifier {
  String? _userId;
  String? _jwt;

  String? get userId => _userId;
  String? get jwt => _jwt;

  set userId(String? id) {
    _userId = id;
    notifyListeners();
  }

  set jwt(String? token) {
    _jwt = token;
    notifyListeners();
  }

  void clearAuth() {
    _userId = null;
    _jwt = null;
    notifyListeners();
  }
}
