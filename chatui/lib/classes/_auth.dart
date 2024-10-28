import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:chat/classes/_url.dart';
import 'package:chat/classes/_message.dart';

class Auth {
  static final PayoorUrl payoorUrl = PayoorUrl();

  Auth();

  Future<Map<String, dynamic>> getValidUser(String jwt) async {
    final String serverUrl = payoorUrl.getBaseUri();
    final String endPoint = '$serverUrl/auth/getvaliduser';

    final Uri uri = Uri.parse(endPoint).replace(queryParameters: {'jwt': jwt});

    try {
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<Message> messages = parseMessages(data);
        Map<String, dynamic> validUser = {
          'messages': messages,
          'username': data['username'],
          'jwt': data['jwt'],
          'hasUsername': data['hasUsername']
        };

        return validUser;
      } else if (response.statusCode == 404) {
        Map<String, dynamic> inValidUser = {
          'invalid': true
        };

        return inValidUser;
      } else {
        throw Exception('Failed to load conversation: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  List<Message> parseMessages(Map<String, dynamic> jsonResponse) {
    final List<dynamic> accountMessages = jsonResponse['accountMessages'] ?? [];
    final String username = jsonResponse['username'] ?? '';
    final String jwt = jsonResponse['jwt'] ?? '';

    return accountMessages
        .map((messageJson) => Message.fromJson(
            messageJson as Map<String, dynamic>,
            username: username,
            jwt: jwt))
        .toList();
  }
}
