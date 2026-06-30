import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/business_models.dart';
import '../data/businesses_repository.dart';

final businessSearchTextProvider = StateProvider<String>((ref) => '');

final businessesListProvider = FutureProvider.autoDispose<List<BusinessListItem>>((ref) {
  final search = ref.watch(businessSearchTextProvider);
  return ref.watch(businessesRepositoryProvider).search(search: search);
});

final businessDetailProvider = FutureProvider.autoDispose.family<BusinessDetail, String>((ref, id) {
  return ref.watch(businessesRepositoryProvider).getById(id);
});
