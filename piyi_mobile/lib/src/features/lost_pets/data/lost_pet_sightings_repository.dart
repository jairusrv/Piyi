import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'lost_pet_sighting_models.dart';

final lostPetSightingsRepositoryProvider = Provider<LostPetSightingsRepository>((ref) {
  return LostPetSightingsRepository(ref.watch(dioProvider));
});

class LostPetSightingsRepository {
  LostPetSightingsRepository(this._dio);

  final Dio _dio;

  Future<List<LostPetSighting>> getSightings(String lostPetId) async {
    final response = await _dio.get('/api/lost-pets/$lostPetId/sightings');

    final data = response.data as List<dynamic>;
    return data.map((x) => LostPetSighting.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<LostPetSighting> createSighting({
    required String lostPetId,
    required num latitude,
    required num longitude,
    String? address,
    String? observation,
    String? photoUrl,
  }) async {
    final response = await _dio.post(
      '/api/lost-pets/$lostPetId/sightings',
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'observation': observation,
        'photoUrl': photoUrl,
      },
    );

    return LostPetSighting.fromJson(response.data as Map<String, dynamic>);
  }
}
