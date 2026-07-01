import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/business_profile.dart';
import '../data/business_profile_repository.dart';

final businessProfileProvider = FutureProvider.autoDispose.family<BusinessProfile, String>((ref, businessId) {
  return ref.watch(businessProfileRepositoryProvider).getByBusinessId(businessId);
});
