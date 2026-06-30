import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_settings_repository.dart';
import '../data/user_alert_setting_model.dart';

final userAlertSettingsProvider = FutureProvider.autoDispose<UserAlertSetting>((ref) {
  return ref.watch(profileSettingsRepositoryProvider).getAlertSettings();
});
