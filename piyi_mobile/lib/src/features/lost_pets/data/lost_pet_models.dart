class LostPetReport {
  LostPetReport({
    required this.id,
    required this.petId,
    required this.petName,
    required this.title,
    required this.description,
    required this.status,
    this.lastSeenAddress,
    this.contactPhone,
    this.rewardAmount,
  });

  final String id;
  final String petId;
  final String petName;
  final String title;
  final String description;
  final String status;
  final String? lastSeenAddress;
  final String? contactPhone;
  final num? rewardAmount;

  factory LostPetReport.fromJson(Map<String, dynamic> json) {
    return LostPetReport(
      id: json['id'] as String,
      petId: json['petId'] as String,
      petName: json['petName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? '',
      lastSeenAddress: json['lastSeenAddress'] as String?,
      contactPhone: json['contactPhone'] as String?,
      rewardAmount: json['rewardAmount'] as num?,
    );
  }
}
