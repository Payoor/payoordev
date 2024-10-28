import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:chat/classes/_message.dart';

class PayoorUrl {
  final Uri baseUri;

  PayoorUrl({String baseUrl = 'http://localhost:3030'})
      : baseUri = Uri.parse(baseUrl);

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
