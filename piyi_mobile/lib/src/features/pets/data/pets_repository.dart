import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'pet_models.dart';

final petsRepositoryProvider = Provider<PetsRepository>((ref) {
  return PetsRepository(ref.watch(dioProvider));
});

class PetsRepository {
  PetsRepository(this._dio);

  final Dio _dio;

  Future<List<Pet>> getMyPets() async {
    final response = await _dio.get('/api/pets');

    final data = response.data as List<dynamic>;
    return data
        .map((item) => Pet.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Pet> getPetById(String id) async {
    final response = await _dio.get('/api/pets/$id');
    return Pet.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Pet> createPet({
    required String name,
    required String speciesId,
    String? breedId,
    String? color,
    String sex = 'Unknown',
    num? weightKg,
    bool isSterilized = false,
  }) async {
    final response = await _dio.post(
      '/api/pets',
      data: {
        'name': name,
        'speciesId': speciesId,
        'breedId': breedId,
        'color': color,
        'birthDate': null,
        'sex': sex,
        'weightKg': weightKg,
        'isSterilized': isSterilized,
        'microchipNumber': null,
        'photoUrl': null,
      },
    );

    return Pet.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<Species>> getSpecies() async {
    final response = await _dio.get('/api/catalogs/species');

    final data = response.data as List<dynamic>;
    return data
        .map((item) => Species.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Breed>> getBreeds(String speciesId) async {
    final response = await _dio.get('/api/catalogs/species/$speciesId/breeds');

    final data = response.data as List<dynamic>;
    return data
        .map((item) => Breed.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
