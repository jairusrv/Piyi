import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage_service.dart';
import 'auth_session.dart';

final authSessionManagerProvider = Provider<AuthSessionManager>((ref) {
  return AuthSessionManager(
    storage: ref.watch(secureStorageServiceProvider),
  );
});

final authSessionStatusProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(authSessionManagerProvider).hasStoredSession();
});

class AuthSessionManager {
  AuthSessionManager({
    required SecureStorageService storage,
  }) : _storage = storage;

  final SecureStorageService _storage;

  Future<AuthSession?> getCurrentSession() async {
    final token = await _storage.getToken();

    if (token == null || token.trim().isEmpty) {
      return null;
    }

    return AuthSession(
      accessToken: token,
      refreshToken: await _storage.getRefreshToken(),
    );
  }

  Future<bool> hasStoredSession() async {
    final session = await getCurrentSession();
    return session?.isValid ?? false;
  }

  Future<void> saveLoginResponse(Map<String, dynamic> json) async {
    final token =
        json['token']?.toString() ??
        json['accessToken']?.toString() ??
        json['jwt']?.toString();

    if (token == null || token.trim().isEmpty) {
      throw Exception('No se recibió token.');
    }

    await _storage.saveToken(token);

    final refreshToken =
        json['refreshToken']?.toString() ??
        json['refresh_token']?.toString();

    if (refreshToken != null && refreshToken.trim().isNotEmpty) {
      await _storage.saveRefreshToken(refreshToken);
    }

    final user = json['user'];

    await _storage.saveUserData(
      userId: json['userId']?.toString() ??
          json['id']?.toString() ??
          (user is Map ? user['id']?.toString() : null),
      email: json['email']?.toString() ??
          (user is Map ? user['email']?.toString() : null),
    );
  }

  Future<void> logout() async {
    await _storage.clearAllSession();
  }
}
