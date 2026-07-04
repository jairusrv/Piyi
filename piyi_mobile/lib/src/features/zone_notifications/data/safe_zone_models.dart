class UserSafeZone {
  const UserSafeZone({
    required this.id,
    required this.userId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    this.address,
    this.city,
    this.region,
    this.country,
    required this.isActive,
  });

  final String id;
  final String userId;
  final String name;
  final num latitude;
  final num longitude;
  final num radiusKm;
  final String? address;
  final String? city;
  final String? region;
  final String? country;
  final bool isActive;

  factory UserSafeZone.fromJson(Map<String, dynamic> json) {
    return UserSafeZone(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String? ?? 'Mi zona segura',
      latitude: json['latitude'] as num? ?? 0,
      longitude: json['longitude'] as num? ?? 0,
      radiusKm: json['radiusKm'] as num? ?? 5,
      address: json['address'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      country: json['country'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class NearbyLostPetAlert {
  const NearbyLostPetAlert({
    required this.lostPetId,
    required this.petName,
    required this.title,
    this.photoUrl,
    this.lastSeenAddress,
    required this.distanceKm,
  });

  final String lostPetId;
  final String petName;
  final String title;
  final String? photoUrl;
  final String? lastSeenAddress;
  final num distanceKm;

  factory NearbyLostPetAlert.fromJson(Map<String, dynamic> json) {
    return NearbyLostPetAlert(
      lostPetId: json['lostPetId'] as String,
      petName: json['petName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      lastSeenAddress: json['lastSeenAddress'] as String?,
      distanceKm: json['distanceKm'] as num? ?? 0,
    );
  }
}
