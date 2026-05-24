import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureAuthStorageProvider = Provider<SecureAuthStorage>((ref) {
  return SecureAuthStorage(ref.watch(secureStorageProvider));
});

class SecureAuthStorage {
  final FlutterSecureStorage _storage;
  SecureAuthStorage(this._storage);

  static const _jwtKey = 'auth_jwt_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _jwtKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _jwtKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _jwtKey);
  }
}