import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:chatuiv2/src/classes/_serverresponse.dart';
import 'package:chatuiv2/src/classes/_urls.dart';
import 'package:chatuiv2/src/classes/_jwtmanager.dart';

class PayStackRoutes {
  static Future<ServerResponse> generatePaymentLink(String? items) async {
    try {
      final uri = Uri.parse('${Urls.baseUrl}/paystack/generate-payment-link');

      final jwt = await JwtManager
          .getToken();

      if (jwt == null) {
        throw Exception('JWT token is null or expired');
      }

      //print(jwt);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin':
              'https://chat.development.payoor.store', 
          'Authorization':
              'Bearer $jwt', 
        },
        body: jsonEncode({"items": items}),
      );

      if (response.statusCode == 200) {
        return ServerResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to generate payment link: $e');
    }
  }
}
