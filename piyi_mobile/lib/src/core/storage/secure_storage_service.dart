import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageServiceProvider = Provider((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  static const _tokenKey = 'auth_token';
  static const _firstNameKey = 'first_name';
  static const _lastNameKey = 'last_name';
  static const _emailKey = 'email';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<void> saveUserProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    if (firstName != null && firstName.trim().isNotEmpty) {
      await _storage.write(key: _firstNameKey, value: firstName.trim());
    }

    if (lastName != null && lastName.trim().isNotEmpty) {
      await _storage.write(key: _lastNameKey, value: lastName.trim());
    }

    if (email != null && email.trim().isNotEmpty) {
      await _storage.write(key: _emailKey, value: email.trim());
    }
  }

  Future<String?> getFirstName() {
    return _storage.read(key: _firstNameKey);
  }

  Future<String?> getLastName() {
    return _storage.read(key: _lastNameKey);
  }

  Future<String?> getEmail() {
    return _storage.read(key: _emailKey);
  }

  Future<void> clearToken() {
    return _storage.delete(key: _tokenKey);
  }

  Future<void> clearAll() {
    return _storage.deleteAll();
  }

  Future<String?> getRefreshToken() async {
    return read('refresh_token');
  }

  Future<void> saveRefreshToken(String? refreshToken) async {
    if (refreshToken == null || refreshToken.isEmpty) {
      return;
    }

    await write('refresh_token', refreshToken);
  }

  Future<void> saveUserData({
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? phoneNumber,
  }) async {
    if (firstName != null && firstName.isNotEmpty) {
      await write('firstName', firstName);
    }

    if (lastName != null && lastName.isNotEmpty) {
      await write('lastName', lastName);
    }

    if (fullName != null && fullName.isNotEmpty) {
      await write('fullName', fullName);
    }

    if (email != null && email.isNotEmpty) {
      await write('email', email);
    }

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      await write('phoneNumber', phoneNumber);
    }
  }

  Future<void> clearAllSession() async {
    await delete('access_token');
    await delete('token');
    await delete('auth_token');
    await delete('jwt');
    await delete('refresh_token');
    await delete('firstName');
    await delete('lastName');
    await delete('fullName');
    await delete('email');
    await delete('phoneNumber');
  }
}
