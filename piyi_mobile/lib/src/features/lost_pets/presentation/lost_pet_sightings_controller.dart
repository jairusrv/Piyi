import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/lost_pet_sighting_models.dart';
import '../data/lost_pet_sightings_repository.dart';

final lostPetSightingsProvider =
    FutureProvider.autoDispose.family<List<LostPetSighting>, String>((ref, lostPetId) {
  return ref.watch(lostPetSightingsRepositoryProvider).getSightings(lostPetId);
});
