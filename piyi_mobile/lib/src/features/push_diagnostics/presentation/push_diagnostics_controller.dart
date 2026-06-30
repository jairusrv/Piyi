import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/device/device_identity_service.dart';
import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/firebase/push_token_service.dart';

class PushDiagnosticsInfo {
  const PushDiagnosticsInfo({
    required this.firebaseInitialized,
    required this.deviceIdentifier,
    required this.platform,
    required this.deviceName,
    required this.pushToken,
  });

  final bool firebaseInitialized;
  final String deviceIdentifier;
  final String platform;
  final String? deviceName;
  final String pushToken;
}

final pushDiagnosticsProvider = FutureProvider.autoDispose<PushDiagnosticsInfo>((ref) async {
  final identity = ref.watch(deviceIdentityServiceProvider);
  final pushTokenService = ref.watch(pushTokenServiceProvider);

  return PushDiagnosticsInfo(
    firebaseInitialized: FirebaseBootstrap.isInitialized,
    deviceIdentifier: await identity.getOrCreateDeviceIdentifier(),
    platform: await identity.getPlatform(),
    deviceName: await identity.getDeviceName(),
    pushToken: await pushTokenService.getPushToken(),
  );
});
