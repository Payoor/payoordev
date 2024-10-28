import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '_storagemanager.dart';
import 'package:uuid/uuid.dart';

class MobileStorageManager implements StorageManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _appUuid;
  static const String _appPrefix = 'chat.payoor.payoorchat';
  static const String _version = 'v1';

  // Private constructor
  MobileStorageManager._();

  // Factory method for async initialization
  static Future<MobileStorageManager> create() async {
    var manager = MobileStorageManager._();
    await manager._initAppUuid();
    return manager;
  }

  Future<void> _initAppUuid() async {
    _appUuid = await _storage.read(key: '${_appPrefix}_app_uuid');

    if (_appUuid == null) {
      _appUuid = const Uuid().v4();
      await _storage.write(key: '${_appPrefix}_app_uuid', value: _appUuid!);
    }
  }

  String _generateKey(String keyName) {
    if (_appUuid == null) {
      throw StateError('SecureStorageManager not properly initialized');
    }
    return '${_appPrefix}_${_version}_${_appUuid}_$keyName';
  }

  @override
  Future<void> saveJwt(String jwt) async {
    await _storage.write(key: _generateKey('jwt'), value: jwt);
  }

  @override
  Future<String?> getJwt() async {
    return await _storage.read(key: _generateKey('jwt'));
  }

  @override
  Future<void> deleteJwt() async {
    await _storage.delete(key: _generateKey('jwt'));
  }
}
