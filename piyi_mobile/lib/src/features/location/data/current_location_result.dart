class CurrentLocationResult {
  const CurrentLocationResult({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.country,
    this.region,
    this.city,
    this.district,
    this.address,
    required this.timestamp,
  });

  final double latitude;
  final double longitude;
  final double? accuracy;
  final String? country;
  final String? region;
  final String? city;
  final String? district;
  final String? address;
  final DateTime timestamp;

  String get coordinatesLabel =>
      'Lat: ${latitude.toStringAsFixed(6)} · Lng: ${longitude.toStringAsFixed(6)}';

  String get placeLabel {
    final parts = [district, city, region, country]
        .where((x) => x != null && x.trim().isNotEmpty)
        .map((x) => x!)
        .toList();

    return parts.isEmpty ? 'Ubicación actual' : parts.join(', ');
  }

  String get accuracyLabel =>
      accuracy == null ? 'Precisión no disponible' : 'Precisión aprox.: ${accuracy!.round()} m';
}
