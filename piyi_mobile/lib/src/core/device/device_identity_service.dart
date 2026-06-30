import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

final deviceIdentityServiceProvider = Provider<DeviceIdentityService>((ref) {
  return DeviceIdentityService();
});

class DeviceIdentityService {
  static const _deviceIdKey = 'piyi_device_identifier';

  final _deviceInfo = DeviceInfoPlugin();
  final _storage = const FlutterSecureStorage();
  final _uuid = const Uuid();

  Future<String> getOrCreateDeviceIdentifier() async {
    final existing = await _storage.read(key: _deviceIdKey);

    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final generated = _uuid.v4();
    await _storage.write(key: _deviceIdKey, value: generated);

    return generated;
  }

  Future<String> getPlatform() async {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'IOS';
    return 'Unknown';
  }

  Future<String?> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        return '${info.manufacturer} ${info.model}';
      }

      if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return '${info.name} ${info.model}';
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String> getDevelopmentPushToken() async {
    final deviceId = await getOrCreateDeviceIdentifier();
    return 'DEV_PUSH_TOKEN_$deviceId';
  }
}
