import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/safe_zone_models.dart';
import '../data/zone_notifications_repository.dart';

final safeZoneProvider = FutureProvider.autoDispose<UserSafeZone?>((ref) {
  return ref.watch(zoneNotificationsRepositoryProvider).getSafeZone();
});

final nearbyLostPetAlertsProvider = FutureProvider.autoDispose<List<NearbyLostPetAlert>>((ref) {
  return ref.watch(zoneNotificationsRepositoryProvider).getNearbyLostPets();
});
