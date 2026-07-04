import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../location/data/current_location_result.dart';
import 'safe_zone_models.dart';

final zoneNotificationsRepositoryProvider = Provider<ZoneNotificationsRepository>((ref) {
  return ZoneNotificationsRepository(ref.watch(dioProvider));
});

class ZoneNotificationsRepository {
  ZoneNotificationsRepository(this._dio);

  final Dio _dio;

  Future<UserSafeZone?> getSafeZone() async {
    try {
      final response = await _dio.get('/api/zone-notifications/safe-zone');
      return UserSafeZone.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<UserSafeZone> saveSafeZone({
    required CurrentLocationResult location,
    required num radiusKm,
  }) async {
    final response = await _dio.put(
      '/api/zone-notifications/safe-zone',
      data: {
        'name': 'Mi zona segura',
        'latitude': location.latitude,
        'longitude': location.longitude,
        'radiusKm': radiusKm,
        'address': location.address,
        'district': location.district,
        'city': location.city,
        'region': location.region,
        'country': location.country,
      },
    );

    return UserSafeZone.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<NearbyLostPetAlert>> getNearbyLostPets() async {
    final response = await _dio.get('/api/zone-notifications/nearby-lost-pets');
    final data = response.data as List<dynamic>;
    return data.map((x) => NearbyLostPetAlert.fromJson(x as Map<String, dynamic>)).toList();
  }
}
