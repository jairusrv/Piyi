import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'lost_pet_models.dart';

final lostPetsRepositoryProvider = Provider<LostPetsRepository>((ref) {
  return LostPetsRepository(ref.watch(dioProvider));
});

class LostPetsRepository {
  LostPetsRepository(this._dio);

  final Dio _dio;

  Future<LostPetReport> reportLostPet({
    required String petId,
    required String title,
    required String description,
    String? lastSeenAddress,
    num? lastSeenLatitude,
    num? lastSeenLongitude,
    String? contactPhone,
    num? rewardAmount,
  }) async {
    final response = await _dio.post(
      '/api/pets/$petId/lost-pets',
      data: {
        'title': title,
        'description': description,
        'lastSeenAddress': lastSeenAddress,
        'lastSeenLatitude': lastSeenLatitude,
        'lastSeenLongitude': lastSeenLongitude,
        'lostDate': DateTime.now().toUtc().toIso8601String(),
        'contactPhone': contactPhone,
        'rewardAmount': rewardAmount,
      },
    );

    return LostPetReport.fromJson(response.data as Map<String, dynamic>);
  }
}
