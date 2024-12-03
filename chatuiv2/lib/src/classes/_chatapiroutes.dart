import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:chatuiv2/src/classes/_serverresponse.dart';
import 'package:chatuiv2/src/classes/_urls.dart';
import 'package:chatuiv2/src/classes/_message.dart';
import 'package:chatuiv2/src/classes/_jwtmanager.dart';

class ChatApiRoutes {
  static Future<ServerResponse> sendUserMessage(Message message) async {
    try {
      final uri = Uri.parse('${Urls.llmUrl}/message/user/send');
      final jwt = JwtManager.getToken();

      //print(jwt);
      //print(message.text);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': 'https://chat.development.payoor.store',
          'Session-ID': jwt.toString(),
          //'Authorization': 'Bearer $jwt',
        },
        body: jsonEncode({
          'text': message.text,
          'currentItems': [
              {"name": "Rice", "description": "White long grain"},
              {"name": "Chicken", "description": "Fresh whole chicken"},
              {"name": "Eggs", "description": "Large brown eggs"},
              {"name": "Beans", "description": "Black beans"}
          ],
          'clienttimestamp': message.clienttimestamp.toIso8601String(),
          'isRead': message.isRead,
        }),
      );

      if (response.statusCode == 200) {
        return ServerResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
