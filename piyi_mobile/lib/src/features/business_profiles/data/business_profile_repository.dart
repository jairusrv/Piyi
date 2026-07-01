import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'business_profile.dart';

final businessProfileRepositoryProvider = Provider<BusinessProfileRepository>((ref) {
  return BusinessProfileRepository(ref.watch(dioProvider));
});

class BusinessProfileRepository {
  BusinessProfileRepository(this._dio);

  final Dio _dio;

  Future<BusinessProfile> getByBusinessId(String businessId) async {
    final response = await _dio.get('/api/business-profiles/$businessId');
    return BusinessProfile.fromJson(response.data as Map<String, dynamic>);
  }
}
