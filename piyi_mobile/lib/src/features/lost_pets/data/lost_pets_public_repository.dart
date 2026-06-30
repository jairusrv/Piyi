import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'lost_pet_public_models.dart';

final lostPetsPublicRepositoryProvider = Provider<LostPetsPublicRepository>((ref) {
  return LostPetsPublicRepository(ref.watch(dioProvider));
});

class LostPetsPublicRepository {
  LostPetsPublicRepository(this._dio);

  final Dio _dio;

  Future<List<LostPetListItem>> getActive({String? city, String? region}) async {
    final response = await _dio.get(
      '/api/lost-pets',
      queryParameters: {
        if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
        if (region != null && region.trim().isNotEmpty) 'region': region.trim(),
      },
    );

    final data = response.data as List<dynamic>;
    return data.map((x) => LostPetListItem.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<LostPetDetail> getById(String id) async {
    final response = await _dio.get('/api/lost-pets/$id');
    return LostPetDetail.fromJson(response.data as Map<String, dynamic>);
  }
}
