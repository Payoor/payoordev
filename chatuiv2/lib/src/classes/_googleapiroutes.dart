import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:chatuiv2/src/classes/_serverresponse.dart';
import 'package:chatuiv2/src/classes/_urls.dart';

class GoogleApiRoutes {
  static Future<ServerResponse> searchPlaces(String query) async {
    try {
      final uri = Uri.parse('${Urls.socketUrl}/googleapi/search-places')
          .replace(queryParameters: {'query': query});

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return ServerResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to fetch places. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error searching places: $error');
    }
  }

  static Future<ServerResponse> getAddressFromCoordinates(
      String address, num? lat, num? lng) async {
    try {
      final queryParams = {
        'address': address,
        if (lat != null) 'lat': lat.toString(),
        if (lng != null) 'lng': lng.toString(),
      };

      final uri = Uri.parse('${Urls.socketUrl}/googleapi/geocode')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return ServerResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed geocode. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed geocode: $error');
    }
  }
}
