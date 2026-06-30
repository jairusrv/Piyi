import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../device/device_identity_service.dart';
import 'firebase_bootstrap.dart';

final pushTokenServiceProvider = Provider<PushTokenService>((ref) {
  return PushTokenService(
    identityService: ref.watch(deviceIdentityServiceProvider),
  );
});

class PushTokenService {
  PushTokenService({
    required DeviceIdentityService identityService,
  }) : _identityService = identityService;

  final DeviceIdentityService _identityService;

  Future<String> getPushToken() async {
    if (!FirebaseBootstrap.isInitialized) {
      return _identityService.getDevelopmentPushToken();
    }

    try {
      final messaging = FirebaseMessaging.instance;

      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await messaging.getToken();

      if (token != null && token.isNotEmpty) {
        return token;
      }

      return _identityService.getDevelopmentPushToken();
    } catch (_) {
      return _identityService.getDevelopmentPushToken();
    }
  }
}
