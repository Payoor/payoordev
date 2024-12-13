import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:chatuiv2/src/classes/_serverresponse.dart';
import 'package:chatuiv2/src/classes/_urls.dart';
import 'package:chatuiv2/src/classes/_jwtmanager.dart';

class OrdersRoute {
  static Future<ServerResponse> getUserOrders() async {
    try {
      final uri = Uri.parse('${Urls.baseUrl}/user/get/orders');
      final jwt = JwtManager.getToken();

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      });

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
