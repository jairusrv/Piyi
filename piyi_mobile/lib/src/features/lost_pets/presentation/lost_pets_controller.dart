import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/lost_pet_public_models.dart';
import '../data/lost_pets_public_repository.dart';

class LostPetsFilter {
  const LostPetsFilter({this.city, this.region});

  final String? city;
  final String? region;
}

final lostPetsFilterProvider = StateProvider<LostPetsFilter>((ref) => const LostPetsFilter());

final lostPetsListProvider = FutureProvider.autoDispose<List<LostPetListItem>>((ref) {
  final filter = ref.watch(lostPetsFilterProvider);
  return ref.watch(lostPetsPublicRepositoryProvider).getActive(city: filter.city, region: filter.region);
});

final lostPetDetailProvider = FutureProvider.autoDispose.family<LostPetDetail, String>((ref, id) {
  return ref.watch(lostPetsPublicRepositoryProvider).getById(id);
});
