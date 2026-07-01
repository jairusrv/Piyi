import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'business_catalog_item.dart';

final businessCatalogRepositoryProvider = Provider<BusinessCatalogRepository>((ref) {
  return BusinessCatalogRepository(ref.watch(dioProvider));
});

class BusinessCatalogRepository {
  BusinessCatalogRepository(this._dio);

  final Dio _dio;

  Future<List<BusinessCatalogItem>> search({
    String? search,
    String? category,
    String? brand,
    String? species,
    String? breed,
    bool availableOnly = true,
  }) async {
    final response = await _dio.get(
      '/api/catalog/search',
      queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (category != null && category.trim().isNotEmpty) 'category': category.trim(),
        if (brand != null && brand.trim().isNotEmpty) 'brand': brand.trim(),
        if (species != null && species.trim().isNotEmpty) 'species': species.trim(),
        if (breed != null && breed.trim().isNotEmpty) 'breed': breed.trim(),
        'availableOnly': availableOnly,
      },
    );

    final data = response.data as List<dynamic>;

    return data
        .map((item) => BusinessCatalogItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<BusinessCatalogItem>> getByBusiness(String businessId) async {
    final response = await _dio.get('/api/catalog/business/$businessId');
    final data = response.data as List<dynamic>;

    return data
        .map((item) => BusinessCatalogItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<BusinessCatalogItem> getById(String id) async {
    final response = await _dio.get('/api/catalog/$id');
    return BusinessCatalogItem.fromJson(response.data as Map<String, dynamic>);
  }
}
