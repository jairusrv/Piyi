import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MapLayerFilter {
  all,
  lostPets,
  businesses,
}

final mapLayerFilterProvider = StateProvider<MapLayerFilter>((ref) => MapLayerFilter.all);
