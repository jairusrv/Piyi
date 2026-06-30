import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/device/device_identity_service.dart';
import '../../../core/network/api_client.dart';
import 'device_models.dart';

final devicesRepositoryProvider = Provider<DevicesRepository>((ref) {
  return DevicesRepository(
    dio: ref.watch(dioProvider),
    identityService: ref.watch(deviceIdentityServiceProvider),
  );
});

class DevicesRepository {
  DevicesRepository({
    required Dio dio,
    required DeviceIdentityService identityService,
  })  : _dio = dio,
        _identityService = identityService;

  final Dio _dio;
  final DeviceIdentityService _identityService;

  Future<List<UserDevice>> getMyDevices() async {
    final response = await _dio.get('/api/users/me/devices');

    final data = response.data as List<dynamic>;
    return data.map((x) => UserDevice.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<UserDevice> registerCurrentDevice() async {
    final deviceIdentifier = await _identityService.getOrCreateDeviceIdentifier();
    final platform = await _identityService.getPlatform();
    final deviceName = await _identityService.getDeviceName();
    final pushToken = await _identityService.getDevelopmentPushToken();

    final response = await _dio.post(
      '/api/users/me/devices',
      data: {
        'deviceIdentifier': deviceIdentifier,
        'platform': platform,
        'pushToken': pushToken,
        'deviceName': deviceName,
        'appVersion': '0.1.0',
      },
    );

    return UserDevice.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deactivateDevice(String deviceId) async {
    await _dio.delete('/api/users/me/devices/$deviceId');
  }
}
