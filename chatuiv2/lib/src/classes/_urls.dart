import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class Urls {
  static final String baseUrl = _determineBaseUrl();

  static final String socketUrl = _determineSocketUrl();

  static final String llmUrl = _determineLLMUrl();

  static String _determineSocketUrl() {
    if (kIsWeb) {
      var location = html.window.location.href;

      print(location);

      if (location.contains('localhost') || location.contains('0.0.0.0')) {
        return 'http://localhost:3031';
      }
      if (location.contains('staging')) {
        return 'https://socket.staging.payoor.store';
      }
      if (location.contains('development')) {
        return 'https://socket.development.payoor.store';
      }
      return 'https://socket.payoor.store';
    }
    return 'http://localhost:3031';
  }

  static String _determineBaseUrl() {
    if (kIsWeb) {
      var location = html.window.location.href;

      print(location);

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

    return 'http://localhost:3030';
  }

  static String _determineLLMUrl() {
    if (kIsWeb) {
      var location = html.window.location.href;

      if (location.contains('localhost')) {
        return 'http://localhost:8084';
      }
      if (location.contains('staging')) {
        return 'https://llmserver.staging.payoor.store';
      }
      if (location.contains('development')) {
        return 'https://llmserver.development.payoor.store';
      }
      return 'https://llmserver.payoor.store';
    }
    return 'http://localhost:8084';
  }
}
