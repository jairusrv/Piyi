class BusinessListItem {
  BusinessListItem({
    required this.id,
    required this.name,
    this.businessTypeName,
    this.description,
    this.phone,
    this.whatsApp,
    this.address,
    this.city,
    this.region,
    this.country,
    this.latitude,
    this.longitude,
    this.logoUrl,
    required this.isVerified,
  });

  final String id;
  final String name;
  final String? businessTypeName;
  final String? description;
  final String? phone;
  final String? whatsApp;
  final String? address;
  final String? city;
  final String? region;
  final String? country;
  final num? latitude;
  final num? longitude;
  final String? logoUrl;
  final bool isVerified;

  factory BusinessListItem.fromJson(Map<String, dynamic> json) {
    return BusinessListItem(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      businessTypeName: json['businessTypeName'] as String?,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      whatsApp: json['whatsApp'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      country: json['country'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      logoUrl: json['logoUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}

class BusinessServiceItem {
  BusinessServiceItem({
    required this.id,
    required this.name,
    this.description,
    this.priceFrom,
    this.priceTo,
    required this.isActive,
  });

  final String id;
  final String name;
  final String? description;
  final num? priceFrom;
  final num? priceTo;
  final bool isActive;

  factory BusinessServiceItem.fromJson(Map<String, dynamic> json) {
    return BusinessServiceItem(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      priceFrom: json['priceFrom'] as num?,
      priceTo: json['priceTo'] as num?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class BusinessPhotoItem {
  BusinessPhotoItem({required this.id, required this.photoUrl});

  final String id;
  final String photoUrl;

  factory BusinessPhotoItem.fromJson(Map<String, dynamic> json) {
    return BusinessPhotoItem(
      id: json['id'] as String,
      photoUrl: json['photoUrl'] as String? ?? '',
    );
  }
}

class BusinessScheduleItem {
  BusinessScheduleItem({
    required this.id,
    required this.dayOfWeek,
    this.opensAt,
    this.closesAt,
    required this.isClosed,
  });

  final String id;
  final int dayOfWeek;
  final String? opensAt;
  final String? closesAt;
  final bool isClosed;

  factory BusinessScheduleItem.fromJson(Map<String, dynamic> json) {
    return BusinessScheduleItem(
      id: json['id'] as String,
      dayOfWeek: json['dayOfWeek'] as int? ?? 0,
      opensAt: json['opensAt'] as String?,
      closesAt: json['closesAt'] as String?,
      isClosed: json['isClosed'] as bool? ?? false,
    );
  }
}

class BusinessDetail {
  BusinessDetail({
    required this.id,
    required this.name,
    this.businessTypeName,
    this.description,
    this.phone,
    this.whatsApp,
    this.email,
    this.website,
    this.facebookUrl,
    this.instagramUrl,
    this.tikTokUrl,
    this.address,
    this.country,
    this.region,
    this.city,
    this.latitude,
    this.longitude,
    this.logoUrl,
    required this.isVerified,
    required this.isActive,
    required this.photos,
    required this.services,
    required this.schedules,
  });

  final String id;
  final String name;
  final String? businessTypeName;
  final String? description;
  final String? phone;
  final String? whatsApp;
  final String? email;
  final String? website;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? tikTokUrl;
  final String? address;
  final String? country;
  final String? region;
  final String? city;
  final num? latitude;
  final num? longitude;
  final String? logoUrl;
  final bool isVerified;
  final bool isActive;
  final List<BusinessPhotoItem> photos;
  final List<BusinessServiceItem> services;
  final List<BusinessScheduleItem> schedules;

  factory BusinessDetail.fromJson(Map<String, dynamic> json) {
    final photos = json['photos'] as List<dynamic>? ?? [];
    final services = json['services'] as List<dynamic>? ?? [];
    final schedules = json['schedules'] as List<dynamic>? ?? [];

    return BusinessDetail(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      businessTypeName: json['businessTypeName'] as String?,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      whatsApp: json['whatsApp'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      tikTokUrl: json['tikTokUrl'] as String?,
      address: json['address'] as String?,
      country: json['country'] as String?,
      region: json['region'] as String?,
      city: json['city'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      logoUrl: json['logoUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      photos: photos.map((x) => BusinessPhotoItem.fromJson(x as Map<String, dynamic>)).toList(),
      services: services.map((x) => BusinessServiceItem.fromJson(x as Map<String, dynamic>)).toList(),
      schedules: schedules.map((x) => BusinessScheduleItem.fromJson(x as Map<String, dynamic>)).toList(),
    );
  }
}
