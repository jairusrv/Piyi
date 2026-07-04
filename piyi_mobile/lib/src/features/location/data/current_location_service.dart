import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'current_location_result.dart';

final currentLocationServiceProvider = Provider<CurrentLocationService>((ref) {
  return CurrentLocationService();
});

class CurrentLocationService {
  Future<bool> ensurePermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return false;

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<CurrentLocationResult?> getCurrentLocation() async {
    final allowed = await ensurePermission();
    if (!allowed) return null;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String? country;
    String? region;
    String? city;
    String? district;
    String? address;

    try {
      final places = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (places.isNotEmpty) {
        final p = places.first;
        country = _clean(p.country);
        region = _clean(p.administrativeArea);
        city = _clean(p.locality) ?? _clean(p.subAdministrativeArea);
        district = _clean(p.subLocality);
        address = [
          _clean(p.street),
          _clean(p.locality),
          _clean(p.administrativeArea),
          _clean(p.country),
        ].whereType<String>().where((x) => x.isNotEmpty).join(', ');
      }
    } catch (_) {}

    return CurrentLocationResult(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      country: country,
      region: region,
      city: city,
      district: district,
      address: address,
      timestamp: DateTime.now(),
    );
  }

  String? _clean(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }
}
