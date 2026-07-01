import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'business_review.dart';

final businessReviewsRepositoryProvider = Provider<BusinessReviewsRepository>((ref) {
  return BusinessReviewsRepository(ref.watch(dioProvider));
});

class BusinessReviewsRepository {
  BusinessReviewsRepository(this._dio);

  final Dio _dio;

  Future<List<BusinessReview>> getReviews(String businessId) async {
    final response = await _dio.get('/api/businesses/$businessId/reviews');
    final data = response.data as List<dynamic>;

    return data
        .map((x) => BusinessReview.fromJson(x as Map<String, dynamic>))
        .toList();
  }

  Future<BusinessReviewSummary> getSummary(String businessId) async {
    final response = await _dio.get('/api/businesses/$businessId/reviews/summary');
    return BusinessReviewSummary.fromJson(response.data as Map<String, dynamic>);
  }

  Future<BusinessReview> createReview({
    required String businessId,
    required int rating,
    String? comment,
    List<String> photos = const [],
  }) async {
    final response = await _dio.post(
      '/api/businesses/$businessId/reviews',
      data: {
        'rating': rating,
        'comment': comment,
        'photos': photos,
      },
    );

    return BusinessReview.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> reportReview({
    required String businessId,
    required String reviewId,
    required String reason,
  }) async {
    await _dio.post(
      '/api/businesses/$businessId/reviews/$reviewId/report',
      data: {'reason': reason},
    );
  }
}
