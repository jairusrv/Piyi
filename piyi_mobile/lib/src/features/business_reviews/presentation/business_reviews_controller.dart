import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/business_review.dart';
import '../data/business_reviews_repository.dart';

final businessReviewsProvider = FutureProvider.autoDispose.family<List<BusinessReview>, String>((ref, businessId) {
  return ref.watch(businessReviewsRepositoryProvider).getReviews(businessId);
});

final businessReviewSummaryProvider = FutureProvider.autoDispose.family<BusinessReviewSummary, String>((ref, businessId) {
  return ref.watch(businessReviewsRepositoryProvider).getSummary(businessId);
});
