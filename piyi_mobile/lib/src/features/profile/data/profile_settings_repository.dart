import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'user_alert_setting_model.dart';

final profileSettingsRepositoryProvider = Provider<ProfileSettingsRepository>((ref) {
  return ProfileSettingsRepository(ref.watch(dioProvider));
});

class ProfileSettingsRepository {
  ProfileSettingsRepository(this._dio);

  final Dio _dio;

  Future<UserAlertSetting> getAlertSettings() async {
    final response = await _dio.get('/api/users/me/alert-settings');
    return UserAlertSetting.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserAlertSetting> updateAlertSettings({
    required bool lostPetAlertsEnabled,
    num? latitude,
    num? longitude,
    required num radiusKm,
    String? country,
    String? region,
    String? city,
  }) async {
    final response = await _dio.put(
      '/api/users/me/alert-settings',
      data: {
        'lostPetAlertsEnabled': lostPetAlertsEnabled,
        'latitude': latitude,
        'longitude': longitude,
        'radiusKm': radiusKm,
        'country': country,
        'region': region,
        'city': city,
      },
    );

    return UserAlertSetting.fromJson(response.data as Map<String, dynamic>);
  }
}
