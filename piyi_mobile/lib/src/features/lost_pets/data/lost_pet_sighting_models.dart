class LostPetSighting {
  LostPetSighting({
    required this.id,
    required this.lostPetId,
    this.userId,
    required this.latitude,
    required this.longitude,
    this.address,
    this.observation,
    this.photoUrl,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String lostPetId;
  final String? userId;
  final num latitude;
  final num longitude;
  final String? address;
  final String? observation;
  final String? photoUrl;
  final String status;
  final String createdAt;

  factory LostPetSighting.fromJson(Map<String, dynamic> json) {
    return LostPetSighting(
      id: json['id'] as String,
      lostPetId: json['lostPetId'] as String,
      userId: json['userId'] as String?,
      latitude: json['latitude'] as num? ?? 0,
      longitude: json['longitude'] as num? ?? 0,
      address: json['address'] as String?,
      observation: json['observation'] as String?,
      photoUrl: json['photoUrl'] as String?,
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}
