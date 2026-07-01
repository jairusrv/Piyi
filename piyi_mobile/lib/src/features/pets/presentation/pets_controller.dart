import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/pet_models.dart';
import '../data/pets_repository.dart';

final petsListProvider = FutureProvider.autoDispose<List<Pet>>((ref) async {
  return ref.watch(petsRepositoryProvider).getMyPets();
});

// Alias usado por pantallas nuevas.
final petsProvider = petsListProvider;

final speciesProvider = FutureProvider.autoDispose<List<Species>>((ref) async {
  return ref.watch(petsRepositoryProvider).getSpecies();
});

final breedsProvider = FutureProvider.autoDispose.family<List<Breed>, String>((ref, speciesId) {
  return ref.watch(petsRepositoryProvider).getBreeds(speciesId);
});

// Alias usado por pantallas nuevas.
final breedsBySpeciesProvider = breedsProvider;

final petDetailProvider = FutureProvider.autoDispose.family<Pet, String>((ref, petId) {
  return ref.watch(petsRepositoryProvider).getPetById(petId);
});
