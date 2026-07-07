import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    storage: ref.watch(secureStorageServiceProvider),
  );
});

class AuthRepository {
  AuthRepository({
    required Dio dio,
    required SecureStorageService storage,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final SecureStorageService _storage;

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

    final token = response.data['token'] as String?;

    if (token == null || token.isEmpty) {
      throw Exception('No se recibió token.');
    }

    await _storage.saveToken(token);
    await _storage.saveUserProfile(email: email);
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

    final token = response.data['token'] as String?;

    if (token == null || token.isEmpty) {
      throw Exception('No se recibió token.');
    }

    await _storage.saveToken(token);
    await _storage.saveUserProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }
}
