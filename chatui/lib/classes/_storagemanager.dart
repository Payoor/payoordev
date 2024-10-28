import 'package:flutter/foundation.dart' show kIsWeb;

import 'mobile_storage_manager.dart';
import 'web_storage_manager.dart';

abstract class StorageManager {
  Future<void> saveJwt(String jwt);
  Future<String?> getJwt();
  Future<void> deleteJwt();

  static Future<StorageManager> create() async {
    if (kIsWeb) {
      return await WebStorageManager.create();
    } else {
      return await MobileStorageManager.create();
    }
  }
}
