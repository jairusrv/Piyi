$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 22-4 - SecureStorage Provider + Legacy Compat..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

if (!(Test-Path ".\piyi_mobile")) {
    Write-Host "ERROR: Ejecuta desde C:\Users\jairo\Documents\Piyi" -ForegroundColor Red
    exit 1
}

$target = ".\piyi_mobile\lib\src\core\storage\secure_storage_service.dart"
$dir = Split-Path $target -Parent
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$content = @'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  SecureStorageService({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String accessTokenKey = 'access_token';
  static const String tokenKey = 'token';
  static const String authTokenKey = 'auth_token';
  static const String jwtKey = 'jwt';
  static const String refreshTokenKey = 'refresh_token';

  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<String?> getAccessToken() async {
    return await read(accessTokenKey) ??
        await read(tokenKey) ??
        await read(authTokenKey) ??
        await read(jwtKey);
  }

  Future<String?> getToken() async {
    return getAccessToken();
  }

  Future<void> saveAccessToken(String? token) async {
    if (token == null || token.isEmpty) {
      return;
    }
    await write(accessTokenKey, token);
    await write(tokenKey, token);
  }

  Future<void> saveToken(String? token) async {
    await saveAccessToken(token);
  }

  Future<String?> getRefreshToken() async {
    return read(refreshTokenKey);
  }

  Future<void> saveRefreshToken(String? refreshToken) async {
    if (refreshToken == null || refreshToken.isEmpty) {
      return;
    }
    await write(refreshTokenKey, refreshToken);
  }

  Future<void> saveUserData({
    String? userId,
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? phoneNumber,
  }) async {
    if (userId != null && userId.isNotEmpty) await write('userId', userId);
    if (firstName != null && firstName.isNotEmpty) await write('firstName', firstName);
    if (lastName != null && lastName.isNotEmpty) await write('lastName', lastName);
    if (fullName != null && fullName.isNotEmpty) await write('fullName', fullName);
    if (email != null && email.isNotEmpty) await write('email', email);
    if (phoneNumber != null && phoneNumber.isNotEmpty) await write('phoneNumber', phoneNumber);
  }

  Future<void> saveUserProfile({
    String? userId,
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? phoneNumber,
  }) async {
    await saveUserData(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );
  }

  Future<String?> getUserId() async => read('userId');
  Future<String?> getFirstName() async => read('firstName');
  Future<String?> getLastName() async => read('lastName');
  Future<String?> getFullName() async => read('fullName');
  Future<String?> getEmail() async => read('email');
  Future<String?> getPhoneNumber() async => read('phoneNumber');

  Future<void> clearAllSession() async {
    await delete(accessTokenKey);
    await delete(tokenKey);
    await delete(authTokenKey);
    await delete(jwtKey);
    await delete(refreshTokenKey);
    await delete('userId');
    await delete('firstName');
    await delete('lastName');
    await delete('fullName');
    await delete('email');
    await delete('phoneNumber');
  }

  Future<void> clearAll() async {
    await clearAllSession();
  }
}
'@

[System.IO.File]::WriteAllText((Resolve-Path $target).Path, $content, $utf8NoBom)

$check = Get-Content $target -Raw
$required = @(
    "secureStorageServiceProvider",
    "Future<String?> getToken",
    "Future<void> saveToken",
    "Future<void> saveUserProfile",
    "Future<void> clearAll()"
)

foreach ($item in $required) {
    if ($check -notmatch [regex]::Escape($item)) {
        Write-Host "ERROR: No se encontró $item después de escribir el archivo." -ForegroundColor Red
        exit 1
    }
}

Write-Host "OK: SecureStorageService compatible reemplazado y validado." -ForegroundColor Green
