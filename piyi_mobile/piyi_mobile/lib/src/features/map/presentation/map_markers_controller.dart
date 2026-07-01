import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/map_marker_models.dart';
import '../data/map_repository.dart';

final lostPetMapMarkersProvider = FutureProvider.autoDispose<List<LostPetMapMarkerItem>>((ref) {
  return ref.watch(mapRepositoryProvider).getLostPets();
});

final businessMapMarkersProvider = FutureProvider.autoDispose<List<BusinessMapMarkerItem>>((ref) {
  return ref.watch(mapRepositoryProvider).getBusinesses();
});
