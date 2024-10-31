import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:chat/classes/_message.dart';

class PayoorUrl {
  final Uri baseUri;
  final String currentUrl = html.window.location.href;

  PayoorUrl({String? baseUrl})
      : baseUri = Uri.parse(() {
          if (kIsWeb) {
            var location = html.window.location.href;

            if (location.contains('localhost')) {
              return 'http://localhost:3030';
            }

            if (location.contains('staging')) {
              return 'https://server.staging.payoor.store';
            }

            if (location.contains('development')) {
              return 'https://server.development.payoor.store';
            }

            return 'https://server.payoor.store';
          }

          return baseUrl ?? 'http://localhost:3030';
        }());

  String getBaseUri() {
    return baseUri.toString();
  }

  Uri getBaseUriWithParams(
      {Map<String, String>? queryParams, required String path}) {
    return baseUri.replace(
      path: path,
      queryParameters: queryParams,
    );
  }

  Uri getConversationUrl(
      {Map<String, String>? queryParams, required String path}) {
    return baseUri.replace(
      path: path,
      queryParameters: queryParams,
    );
  }

  Uri saveConversationUrl(
      {Map<String, String>? queryParams, required String path}) {
    return baseUri.replace(
      path: path,
      queryParameters: queryParams,
    );
  }

  Future<http.Response> getConversation(
      {Map<String, String>? queryParams, required String path}) async {
    final url = getConversationUrl(queryParams: queryParams, path: path);
    return await http.get(url);
  }

  Future<http.Response> saveConversation({
    Map<String, String>? queryParams,
    required String path,
    required List<dynamic>
        body, // Add this parameter to specify the request body
  }) async {
    final url = saveConversationUrl(queryParams: queryParams, path: path);

    final encodedBody = jsonEncode(body);
    return await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: encodedBody,
    );
  }
}
