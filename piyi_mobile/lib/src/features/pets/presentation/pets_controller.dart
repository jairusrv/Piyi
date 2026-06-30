import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/pet_models.dart';
import '../data/pets_repository.dart';

final petsListProvider = FutureProvider.autoDispose<List<Pet>>((ref) async {
  return ref.watch(petsRepositoryProvider).getMyPets();
});

final speciesProvider = FutureProvider.autoDispose<List<Species>>((ref) async {
  return ref.watch(petsRepositoryProvider).getSpecies();
});

final breedsProvider =
    FutureProvider.autoDispose.family<List<Breed>, String>((ref, speciesId) {
  return ref.watch(petsRepositoryProvider).getBreeds(speciesId);
});

final petDetailProvider =
    FutureProvider.autoDispose.family<Pet, String>((ref, petId) {
  return ref.watch(petsRepositoryProvider).getPetById(petId);
});
