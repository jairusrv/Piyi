import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../data/current_location_service.dart';

final currentLocationProvider = FutureProvider.autoDispose<Position?>((ref) {
  return ref.watch(currentLocationServiceProvider).getCurrentLocation();
});
