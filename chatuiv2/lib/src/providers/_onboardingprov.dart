import 'package:flutter/material.dart';

class OnboardingProv extends ChangeNotifier {
  String _onboardingMessage = "";

  String get onboardingMessage => _onboardingMessage;

  set onboardingMessage(String message) {
    _onboardingMessage = message;
    notifyListeners();
  }
}
