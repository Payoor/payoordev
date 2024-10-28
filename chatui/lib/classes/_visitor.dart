import 'dart:html' as html;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:chat/classes/_message.dart';
import 'package:chat/classes/_url.dart';

import 'package:chat/providers/_message_provider.dart';

class Visitor {
  late String identifier;
  late String visitorTokenKey;
  String? _appUuid;
  static const String _appPrefix = 'chat.payoor.payoorchat';
  static const String _version = 'v1';
  final List<Message> _messages = [];
  static final PayoorUrl payoorUrl = PayoorUrl();

  Visitor() {
    visitorTokenKey = '${_appPrefix}_visitor';

    String? visitorId = getStoredVisitorToken();

    if (visitorId == null) {
      identifier = generateVisitorIdentity();
      html.window.localStorage[visitorTokenKey] = identifier;
    } else {
      identifier = visitorId;
    }
  }

  String generateVisitorIdentity() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _appUuid = const Uuid().v4();

    return 'V${timestamp}_${_appUuid}_${_appPrefix}_$_version';
  }

  String? getStoredVisitorToken() {
    return html.window.localStorage[visitorTokenKey];
  }

  Future<void> saveMessagesToServer(List<Message> messages) async {
    int _savedCount = 0;

    for (final message in messages) {
      Map<String, dynamic> messageData = {
        'message': message.value,
        'isUser': message.isUser,
        'isLoggedIn': message.isLoggedIn,
        'username': message.username,
        'jwt': message.jwt,
        'timestamp': message.timeStamp,
        'visitoridentifier': identifier,
        'id': message.id
      };

      if (messageData['isUser'] && messageData['id'] == null) {
        await saveMessageToServer(messageData);
      }

      _savedCount++;
    }
  }

  Future<Map<String, dynamic>> getUnAuthenticatedMsg() async {
    final String serverUrl = payoorUrl.getBaseUri();
    final String endPoint = '$serverUrl/auth/getunauthmsg';
    String? visitorId = getStoredVisitorToken();
    final Uri uri =
        Uri.parse(endPoint).replace(queryParameters: {'visitorId': visitorId});
    try {
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        return data;
      } else {
        throw Exception('Failed to load conversation: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  /*Future<Map<String, dynamic>> getVisitorDataFromServer() async {
    final String serverUrl = payoorUrl.getBaseUri();
    final String endPoint = '$serverUrl/auth/getvisitor';
    String? visitorId = getStoredVisitorToken();
    final Uri uri =
        Uri.parse(endPoint).replace(queryParameters: {'visitorId': visitorId});

    try {
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load conversation: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return {};
    }
  }*/

  Future<void> saveMessageToServer(Map<String, dynamic> message) async {
    final String serverUrl = payoorUrl.getBaseUri();
    final String endPoint = '$serverUrl/message/visitor';
    final Uri uri = Uri.parse(endPoint);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(message),
      );

      if (response.statusCode == 201) {
        print('Message saved successfully: ${message['message']}');
        return;
      } else {
        throw Exception('Failed to load conversation: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
