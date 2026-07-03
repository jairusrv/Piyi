import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  SecureStorageService();

  static const _storage = FlutterSecureStorage();

  static const _tokenKeys = <String>[
    'auth_token',
    'access_token',
    'token',
    'jwt',
    'piyi_access_token',
  ];

  static const _refreshTokenKeys = <String>[
    'refresh_token',
    'piyi_refresh_token',
  ];

  Future<void> saveToken(String token) async {
    final clean = token.trim();

    if (clean.isEmpty) {
      throw ArgumentError('El token no puede estar vacío.');
    }

    for (final key in _tokenKeys) {
      await _storage.write(key: key, value: clean);
    }

    await _storage.write(
      key: 'session_saved_at',
      value: DateTime.now().toIso8601String(),
    );
  }

  Future<String?> getToken() async {
    for (final key in _tokenKeys) {
      final value = await _storage.read(key: key);

      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  Future<void> saveRefreshToken(String token) async {
    final clean = token.trim();

    if (clean.isEmpty) {
      return;
    }

    for (final key in _refreshTokenKeys) {
      await _storage.write(key: key, value: clean);
    }
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

  Future<void> saveUserData({
    String? userId,
    String? email,
  }) async {
    if (userId != null && userId.trim().isNotEmpty) {
      await _storage.write(key: 'user_id', value: userId.trim());
    }

    if (email != null && email.trim().isNotEmpty) {
      await _storage.write(key: 'email', value: email.trim());
    }
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.trim().isNotEmpty;
  }

  Future<void> clearToken() async {
    for (final key in _tokenKeys) {
      await _storage.delete(key: key);
    }

    for (final key in _refreshTokenKeys) {
      await _storage.delete(key: key);
    }

    await _storage.delete(key: 'user');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'session_saved_at');
  }

  Future<void> clearAllSession() => clearToken();
}
