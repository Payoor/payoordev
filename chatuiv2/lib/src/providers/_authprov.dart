import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_jwtmanager.dart';
import 'package:chatuiv2/src/classes/_authapiroutes.dart';

class AuthProv extends ChangeNotifier {
  String? _userId;
  String? _jwt;
  bool _isLoading = false;
  bool _error = false;
  Map<String, dynamic>? _userData = null;

  String? get userId => _userId;
  String? get jwt => _jwt;
  bool get isLoading => _isLoading;
  bool get error => _error;
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

  Future<void> checkForUser() async {
    try {
      _isLoading = true;
      notifyListeners();

      final String? jwtToken = JwtManager.getToken();

      if (jwtToken == null || jwtToken.isEmpty) {
        _resetState(clearData: true);
        return;
      }

      final response = await AuthApiRoutes.getValidUser(jwtToken);
      final userData = response.data['user'];

      _userData = userData;
      _jwt = jwtToken;
      _error = false;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('Error checking for user: $error');
      _resetState(hasError: true, clearData: true);
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_jwt == null) {
        _resetState(clearData: true);
        return;
      }

      final response = await AuthApiRoutes.logoutUser(_jwt!);

      JwtManager.removeToken();

      _resetState(clearData: true);
    } catch (error) {
      print('Error during logout: $error');
      JwtManager.removeToken();
      _resetState(clearData: true, hasError: true);
    }
  }

  void _resetState({bool clearData = false, bool hasError = false}) {
    _isLoading = false;
    _error = hasError;
    if (clearData) {
      _userData = null;
      _jwt = null;
      _userId = null;
    }
    notifyListeners();
  }

  void clearAuth() {
    _resetState(clearData: true);
  }
}
