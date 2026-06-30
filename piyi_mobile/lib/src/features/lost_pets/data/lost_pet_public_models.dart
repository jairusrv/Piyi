class LostPetListItem {
  LostPetListItem({
    required this.id,
    required this.petId,
    required this.petName,
    this.petPhotoUrl,
    required this.speciesName,
    required this.title,
    this.lastSeenAddress,
    required this.lostDate,
    required this.status,
  });

  final String id;
  final String petId;
  final String petName;
  final String? petPhotoUrl;
  final String speciesName;
  final String title;
  final String? lastSeenAddress;
  final String lostDate;
  final String status;

  factory LostPetListItem.fromJson(Map<String, dynamic> json) {
    return LostPetListItem(
      id: json['id'] as String,
      petId: json['petId'] as String,
      petName: json['petName'] as String? ?? '',
      petPhotoUrl: json['petPhotoUrl'] as String?,
      speciesName: json['speciesName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      lastSeenAddress: json['lastSeenAddress'] as String?,
      lostDate: json['lostDate'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}

class LostPetDetail {
  LostPetDetail({
    required this.id,
    required this.petId,
    required this.petName,
    this.petPhotoUrl,
    required this.speciesName,
    this.breedName,
    this.color,
    required this.title,
    required this.description,
    this.lastSeenAddress,
    required this.lostDate,
    required this.status,
    this.contactPhone,
    this.rewardAmount,
  });

  final String id;
  final String petId;
  final String petName;
  final String? petPhotoUrl;
  final String speciesName;
  final String? breedName;
  final String? color;
  final String title;
  final String description;
  final String? lastSeenAddress;
  final String lostDate;
  final String status;
  final String? contactPhone;
  final num? rewardAmount;

  factory LostPetDetail.fromJson(Map<String, dynamic> json) {
    return LostPetDetail(
      id: json['id'] as String,
      petId: json['petId'] as String,
      petName: json['petName'] as String? ?? '',
      petPhotoUrl: json['petPhotoUrl'] as String?,
      speciesName: json['speciesName'] as String? ?? '',
      breedName: json['breedName'] as String?,
      color: json['color'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      lastSeenAddress: json['lastSeenAddress'] as String?,
      lostDate: json['lostDate'] as String? ?? '',
      status: json['status'] as String? ?? '',
      contactPhone: json['contactPhone'] as String?,
      rewardAmount: json['rewardAmount'] as num?,
    );
  }
}
