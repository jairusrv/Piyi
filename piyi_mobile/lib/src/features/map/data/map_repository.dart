import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'map_marker_models.dart';

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepository(ref.watch(dioProvider));
});

class MapRepository {
  MapRepository(this._dio);

  final Dio _dio;

  Future<List<LostPetMapMarkerItem>> getLostPets() async {
    final response = await _dio.get('/api/map/lost-pets');
    final data = response.data as List<dynamic>;
    return data.map((x) => LostPetMapMarkerItem.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<List<BusinessMapMarkerItem>> getBusinesses() async {
    final response = await _dio.get('/api/map/businesses');
    final data = response.data as List<dynamic>;
    return data.map((x) => BusinessMapMarkerItem.fromJson(x as Map<String, dynamic>)).toList();
  }
}
