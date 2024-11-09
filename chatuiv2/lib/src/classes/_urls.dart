import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class Urls {
  static final String baseUrl = _determineBaseUrl();

  static String _determineBaseUrl() {
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
    return 'http://localhost:3030';
  }
}
