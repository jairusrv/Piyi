import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';
import 'auth_session_manager.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    storage: ref.watch(secureStorageServiceProvider),
    sessionManager: ref.watch(authSessionManagerProvider),
  );
});

class AuthRepository {
  AuthRepository({
    required Dio dio,
    required SecureStorageService storage,
    required AuthSessionManager sessionManager,
  })  : _dio = dio,
        _storage = storage,
        _sessionManager = sessionManager;

  final Dio _dio;
  final SecureStorageService _storage;
  final AuthSessionManager _sessionManager;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/api/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      await _sessionManager.saveLoginResponse(data);
      return;
    }

    if (data is Map) {
      await _sessionManager.saveLoginResponse(
        data.map((key, value) => MapEntry(key.toString(), value)),
      );
      return;
    }

    throw Exception('Respuesta de login inválida.');
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final response = await _dio.post(
      '/api/auth/register',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      },
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      await _sessionManager.saveLoginResponse(data);
      return;
    }

    if (data is Map) {
      await _sessionManager.saveLoginResponse(
        data.map((key, value) => MapEntry(key.toString(), value)),
      );
      return;
    }

    throw Exception('Respuesta de registro inválida.');
  }

  Future<bool> hasSession() {
    return _storage.hasToken();
  }

  Future<void> logout() async {
    await _sessionManager.logout();
  }
}
