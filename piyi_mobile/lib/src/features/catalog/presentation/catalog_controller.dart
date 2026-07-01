import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/business_catalog_item.dart';
import '../data/business_catalog_repository.dart';

class CatalogSearchState {
  const CatalogSearchState({
    this.search = '',
    this.category = '',
    this.brand = '',
    this.species = '',
    this.breed = '',
    this.availableOnly = true,
  });

  final String search;
  final String category;
  final String brand;
  final String species;
  final String breed;
  final bool availableOnly;

  CatalogSearchState copyWith({
    String? search,
    String? category,
    String? brand,
    String? species,
    String? breed,
    bool? availableOnly,
  }) {
    return CatalogSearchState(
      search: search ?? this.search,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      availableOnly: availableOnly ?? this.availableOnly,
    );
  }
}

final catalogSearchStateProvider = StateProvider<CatalogSearchState>((ref) {
  return const CatalogSearchState();
});

final catalogSearchResultsProvider = FutureProvider.autoDispose<List<BusinessCatalogItem>>((ref) {
  final state = ref.watch(catalogSearchStateProvider);

  return ref.watch(businessCatalogRepositoryProvider).search(
        search: state.search,
        category: state.category,
        brand: state.brand,
        species: state.species,
        breed: state.breed,
        availableOnly: state.availableOnly,
      );
});

final catalogItemDetailProvider = FutureProvider.autoDispose.family<BusinessCatalogItem, String>((ref, id) {
  return ref.watch(businessCatalogRepositoryProvider).getById(id);
});
