import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:chatuiv2/src/classes/_serverresponse.dart';
import 'package:chatuiv2/src/classes/_urls.dart';

class ProductRoute {
  static Future<ServerResponse> getProductImage(String productId) async {
    try {
      final uri =
          Uri.parse('${Urls.llmUrl}/product/images?product_id=$productId');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': 'https://chat.development.payoor.store'
          //'Authorization': 'Bearer $jwt',
        },
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

  static Future<ServerResponse> getProductVariants(String productId) async {
    try {
      final uri =
          Uri.parse('${Urls.llmUrl}/product/variants?product_id=$productId');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': 'https://chat.development.payoor.store'
          //'Authorization': 'Bearer $jwt',
        },
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

  static Future<ServerResponse> addProductToBookMarks(String productId, String? userId) async {
    try {
      final uri =
          Uri.parse('${Urls.llmUrl}/product/bookmark?product_id=$productId&user_id=$userId');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': 'https://chat.development.payoor.store'
          //'Authorization': 'Bearer $jwt',
        },
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

  static Future<ServerResponse> checkIfProductInBookMarks(String productId, String? userId) async {
    try {
      final uri =
          Uri.parse('${Urls.llmUrl}/product/bookmark/check?product_id=$productId&user_id=$userId');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': 'https://chat.development.payoor.store'
          //'Authorization': 'Bearer $jwt',
        },
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
