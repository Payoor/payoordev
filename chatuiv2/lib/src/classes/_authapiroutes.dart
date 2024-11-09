import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:chatuiv2/src/classes/_serverresponse.dart';
import 'package:chatuiv2/src/classes/_urls.dart';

class AuthApiRoutes {
  static Future<ServerResponse> getOtp(String? email) async {
    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/auth/email/otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return ServerResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get OTP: $e');
    }
  }

  static Future<ServerResponse> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/auth/email/verify'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'otp': otp, 'email': email}),
      );

      if (response.statusCode == 200) {
        return ServerResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  static Future<ServerResponse> handleSignUp({
    required String name,
    required String email,
    required String otp,
    required String phone,
    required String location,
    required String shoppingList,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'otp': otp,
          'phone': phone,
          'location': location,
          'shoppingList': shoppingList,
        }),
      );

      if (response.statusCode == 200) {
        return ServerResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to sign up: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  static Future<ServerResponse> getJWT(String id) async {
    try {
      final uri = Uri.parse('${Urls.baseUrl}/auth/genjwt').replace(
        queryParameters: {'id': id},
      );

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return ServerResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get JWT. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get JWT: $e');
    }
  }
}
