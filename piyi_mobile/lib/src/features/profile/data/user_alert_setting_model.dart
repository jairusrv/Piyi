class UserAlertSetting {
  UserAlertSetting({
    required this.id,
    required this.lostPetAlertsEnabled,
    this.latitude,
    this.longitude,
    required this.radiusKm,
    this.country,
    this.region,
    this.city,
  });

  final String id;
  final bool lostPetAlertsEnabled;
  final num? latitude;
  final num? longitude;
  final num radiusKm;
  final String? country;
  final String? region;
  final String? city;

  factory UserAlertSetting.fromJson(Map<String, dynamic> json) {
    return UserAlertSetting(
      id: json['id'] as String,
      lostPetAlertsEnabled: json['lostPetAlertsEnabled'] as bool? ?? true,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      radiusKm: json['radiusKm'] as num? ?? 10,
      country: json['country'] as String?,
      region: json['region'] as String?,
      city: json['city'] as String?,
    );
  }
}
