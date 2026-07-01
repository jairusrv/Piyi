class BusinessProfile {
  const BusinessProfile({
    required this.id,
    required this.businessId,
    required this.businessName,
    this.businessTypeName,
    this.logoUrl,
    this.bannerUrl,
    this.shortDescription,
    this.longDescription,
    this.story,
    this.mission,
    this.specialties,
    this.languages,
    required this.acceptsSinpe,
    required this.acceptsCard,
    required this.hasParking,
    required this.isAccessible,
    required this.hasEmergency24h,
    required this.hasHomeService,
    required this.hasOwnDelivery,
    this.websiteUrl,
    this.facebookUrl,
    this.instagramUrl,
    this.tikTokUrl,
    this.youTubeUrl,
    this.phone,
    this.whatsApp,
    this.email,
    this.address,
    this.city,
    this.region,
    this.country,
    this.latitude,
    this.longitude,
    required this.isVerified,
    required this.isProviderPro,
    required this.gallery,
  });

  final String id;
  final String businessId;
  final String businessName;
  final String? businessTypeName;
  final String? logoUrl;
  final String? bannerUrl;
  final String? shortDescription;
  final String? longDescription;
  final String? story;
  final String? mission;
  final String? specialties;
  final String? languages;
  final bool acceptsSinpe;
  final bool acceptsCard;
  final bool hasParking;
  final bool isAccessible;
  final bool hasEmergency24h;
  final bool hasHomeService;
  final bool hasOwnDelivery;
  final String? websiteUrl;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? tikTokUrl;
  final String? youTubeUrl;
  final String? phone;
  final String? whatsApp;
  final String? email;
  final String? address;
  final String? city;
  final String? region;
  final String? country;
  final num? latitude;
  final num? longitude;
  final bool isVerified;
  final bool isProviderPro;
  final List<String> gallery;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id: json['id'] as String? ?? '',
      businessId: json['businessId'] as String,
      businessName: json['businessName'] as String? ?? '',
      businessTypeName: json['businessTypeName'] as String?,
      logoUrl: json['logoUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      shortDescription: json['shortDescription'] as String?,
      longDescription: json['longDescription'] as String?,
      story: json['story'] as String?,
      mission: json['mission'] as String?,
      specialties: json['specialties'] as String?,
      languages: json['languages'] as String?,
      acceptsSinpe: json['acceptsSinpe'] as bool? ?? false,
      acceptsCard: json['acceptsCard'] as bool? ?? false,
      hasParking: json['hasParking'] as bool? ?? false,
      isAccessible: json['isAccessible'] as bool? ?? false,
      hasEmergency24h: json['hasEmergency24h'] as bool? ?? false,
      hasHomeService: json['hasHomeService'] as bool? ?? false,
      hasOwnDelivery: json['hasOwnDelivery'] as bool? ?? false,
      websiteUrl: json['websiteUrl'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      tikTokUrl: json['tikTokUrl'] as String?,
      youTubeUrl: json['youTubeUrl'] as String?,
      phone: json['phone'] as String?,
      whatsApp: json['whatsApp'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      country: json['country'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      isVerified: json['isVerified'] as bool? ?? false,
      isProviderPro: json['isProviderPro'] as bool? ?? false,
      gallery: (json['gallery'] as List<dynamic>? ?? [])
          .map((x) => x.toString())
          .toList(),
    );
  }
}
