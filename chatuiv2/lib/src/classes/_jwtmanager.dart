import 'dart:html' as html;

class JwtManager {
  static void saveToken(String token) {
    html.window.localStorage['jwtToken'] = token;
  }

  static String? getToken() {
    return html.window.localStorage['jwtToken'];
  }

  static void removeToken() {
    html.window.localStorage.remove('jwtToken');
  }

  static bool isAuthenticated() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}
