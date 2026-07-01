import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) {
  return const AuthTokenStore();
});

class AuthTokenStore {
  const AuthTokenStore();

  static const _storage = FlutterSecureStorage();

  // Mantenemos varias claves por compatibilidad con versiones previas.
  static const _accessTokenKeys = [
    'access_token',
    'token',
    'jwt',
    'auth_token',
    'piyi_access_token',
  ];

  static const _refreshTokenKeys = [
    'refresh_token',
    'piyi_refresh_token',
  ];

  Future<String?> getAccessToken() async {
    for (final key in _accessTokenKeys) {
      final value = await _storage.read(key: key);
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
    await _storage.write(key: 'piyi_access_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    for (final key in _refreshTokenKeys) {
      final value = await _storage.read(key: key);
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
    await _storage.write(key: 'piyi_refresh_token', value: token);
  }

  Future<bool> hasSession() async {
    final token = await getAccessToken();
    return token != null && token.trim().isNotEmpty;
  }

  Future<void> clearSession() async {
    for (final key in _accessTokenKeys) {
      await _storage.delete(key: key);
    }

    for (final key in _refreshTokenKeys) {
      await _storage.delete(key: key);
    }

    await _storage.delete(key: 'user');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'email');
  }
}
