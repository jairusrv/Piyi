import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/current_location_result.dart';
import '../data/current_location_service.dart';

final currentLocationProvider = FutureProvider.autoDispose<CurrentLocationResult?>((ref) {
  return ref.watch(currentLocationServiceProvider).getCurrentLocation();
});

final selectedCurrentLocationProvider = StateProvider<CurrentLocationResult?>((ref) => null);
