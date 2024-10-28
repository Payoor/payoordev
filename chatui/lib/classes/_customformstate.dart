import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class CustomFormState {
  final String inputType;
  final String hintText;
  final int? maxLines;
  final int? maxLength;
  final TextInputType keyboardType;

  CustomFormState({
    required this.inputType,
    required this.hintText,
    required this.maxLines,
    required this.maxLength,
    this.keyboardType = TextInputType.text, // Default value
  });

  bool _isValidNigerianPhoneNumber(String phone) {
    String cleanedNumber = phone.replaceAll(RegExp(r'\D'), '');
    RegExp nigerianNumberRegex = RegExp(r'^(?:0|234)\d{10}$');
    return nigerianNumberRegex.hasMatch(cleanedNumber);
  }

  bool _isValidEmainAddress(String email) {
    bool isValid = EmailValidator.validate(email);

    return isValid;
  }

  bool isInputReady(userchat) {
    if (userchat.isEmpty) {
      return false;
    }

    if (inputType == "isPhonenumberInput") {
      String phoneNumber = userchat;

      if (!_isValidNigerianPhoneNumber(phoneNumber)) {
        return false;
      }
    }

    if (inputType == "isEmailInput") {
      String email = userchat;

      if (!_isValidEmainAddress(email)) {
        return false;
      }
    }

    if (inputType == "isOtpInput") {
      String otp = userchat;

      if (otp.length != 6) {
        return false;
      }
    }

    if (inputType == "isNameinput") {
      String username = userchat;

      if (username.isEmpty) {
        return false;
      }
    }

    if (inputType == "isLoggedInInput") {
      String message = userchat;

      if (message.isEmpty) {
        return false;
      }
    }

    return true;
  }
}
