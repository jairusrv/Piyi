class LostPetMapMarkerItem {
  LostPetMapMarkerItem({
    required this.id,
    required this.petName,
    required this.title,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
    this.rewardAmount,
    this.lastSeenAddress,
  });

  final String id;
  final String petName;
  final String title;
  final num latitude;
  final num longitude;
  final String? photoUrl;
  final num? rewardAmount;
  final String? lastSeenAddress;

  factory LostPetMapMarkerItem.fromJson(Map<String, dynamic> json) {
    return LostPetMapMarkerItem(
      id: json['id'] as String,
      petName: json['petName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      latitude: json['latitude'] as num? ?? 0,
      longitude: json['longitude'] as num? ?? 0,
      photoUrl: json['photoUrl'] as String?,
      rewardAmount: json['rewardAmount'] as num?,
      lastSeenAddress: json['lastSeenAddress'] as String?,
    );
  }
}

class BusinessMapMarkerItem {
  BusinessMapMarkerItem({
    required this.id,
    required this.name,
    this.businessTypeName,
    required this.latitude,
    required this.longitude,
    this.logoUrl,
    required this.isVerified,
    this.address,
  });

  final String id;
  final String name;
  final String? businessTypeName;
  final num latitude;
  final num longitude;
  final String? logoUrl;
  final bool isVerified;
  final String? address;

  factory BusinessMapMarkerItem.fromJson(Map<String, dynamic> json) {
    return BusinessMapMarkerItem(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      businessTypeName: json['businessTypeName'] as String?,
      latitude: json['latitude'] as num? ?? 0,
      longitude: json['longitude'] as num? ?? 0,
      logoUrl: json['logoUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      address: json['address'] as String?,
    );
  }
}
