import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_session.dart';

final authSessionStoreProvider = Provider<AuthSessionStore>((ref) {
  return const AuthSessionStore();
});

class AuthSessionStore {
  const AuthSessionStore();

  static const _storage = FlutterSecureStorage();

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

  Future<AuthSession?> getSession() async {
    final accessToken = await getAccessToken();

    if (accessToken == null || accessToken.trim().isEmpty) {
      return null;
    }

    return AuthSession(
      accessToken: accessToken,
      refreshToken: await getRefreshToken(),
      userId: await _storage.read(key: 'user_id'),
      email: await _storage.read(key: 'email'),
      savedAt: DateTime.tryParse(await _storage.read(key: 'session_saved_at') ?? ''),
    );
  }

  Future<String?> getAccessToken() async {
    for (final key in _accessTokenKeys) {
      final value = await _storage.read(key: key);
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }

    return null;
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

  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
    String? userId,
    String? email,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'piyi_access_token', value: accessToken);

    if (refreshToken != null && refreshToken.trim().isNotEmpty) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
      await _storage.write(key: 'piyi_refresh_token', value: refreshToken);
    }

    if (userId != null) {
      await _storage.write(key: 'user_id', value: userId);
    }

    if (email != null) {
      await _storage.write(key: 'email', value: email);
    }

    await _storage.write(
      key: 'session_saved_at',
      value: DateTime.now().toIso8601String(),
    );
  }

  Future<bool> hasSession() async {
    final session = await getSession();
    return session?.isValid ?? false;
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
    await _storage.delete(key: 'session_saved_at');
  }
}
