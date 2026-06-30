import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'business_models.dart';

final businessesRepositoryProvider = Provider<BusinessesRepository>((ref) {
  return BusinessesRepository(ref.watch(dioProvider));
});

class BusinessesRepository {
  BusinessesRepository(this._dio);

  final Dio _dio;

  Future<List<BusinessListItem>> search({String? search}) async {
    final response = await _dio.get(
      '/api/businesses',
      queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );

    final data = response.data as List<dynamic>;
    return data.map((x) => BusinessListItem.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<BusinessDetail> getById(String id) async {
    final response = await _dio.get('/api/businesses/$id');
    return BusinessDetail.fromJson(response.data as Map<String, dynamic>);
  }
}
