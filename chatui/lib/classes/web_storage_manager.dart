import 'dart:html' as html;
import 'package:uuid/uuid.dart';

import '_storagemanager.dart';

class WebStorageManager implements StorageManager {
  String? _appUuid;
  static const String _appPrefix = 'chat.payoor.payoorchat';
  static const String _version = 'v1';

  WebStorageManager._();

  static Future<WebStorageManager> create() async {
    var manager = WebStorageManager._();
    await manager._initAppUuid();
    return manager;
  }

  Future<void> _initAppUuid() async {
    _appUuid = html.window.localStorage['${_appPrefix}_app_uuid'];
    if (_appUuid == null || _appUuid!.isEmpty) {
      _appUuid = const Uuid().v4();
      html.window.localStorage['${_appPrefix}_app_uuid'] = _appUuid!;
    }
  }

  String _generateKey(String keyName) =>
      '${_appPrefix}_${_version}_${_appUuid}_$keyName';

  @override
  Future<void> saveJwt(String jwt) async {
    String tokenKey = _generateKey("jwt");
    html.window.localStorage[tokenKey] = jwt;
    // Set expiration
    final expirationDate = DateTime.now().add(const Duration(days: 1));
    html.window.localStorage['${tokenKey}_expiration'] =
        expirationDate.toIso8601String();
  }

  @override
  Future<String?> getJwt() async {
    String tokenKey = _generateKey("jwt");
    String? jwt = html.window.localStorage[tokenKey];
    String? expirationString =
        html.window.localStorage['${tokenKey}_expiration'];

    if (jwt != null && expirationString != null) {

      DateTime expiration = DateTime.parse(expirationString);
      if (DateTime.now().isBefore(expiration)) {
        return jwt;
      } else if (DateTime.now().isAfter(expiration)) {
        deleteJwt();
        return null;
      }
    }
    
    return null;
  }

  

  @override
  Future<void> deleteJwt() async {
    String tokenKey = _generateKey("jwt");
    html.window.localStorage.remove(tokenKey);
    html.window.localStorage.remove('${tokenKey}_expiration');
  }
}
