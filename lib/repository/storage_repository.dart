import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository {
  final storage = const FlutterSecureStorage();

  void saveValue(final String key, final String value) async {
    storage.write(key: key, value: value);
  }

  Future<String?> getValue(final String key) async {
    return await storage.read(key: key);
  }

  void deleteValue() {
    storage.deleteAll();
  }
}
