class BusinessReview {
  const BusinessReview({
    required this.id,
    required this.businessId,
    required this.userId,
    this.userName,
    required this.rating,
    this.comment,
    required this.photos,
    this.businessReply,
    this.businessRepliedAt,
    required this.isReported,
    required this.isApproved,
    required this.createdAt,
  });

  final String id;
  final String businessId;
  final String userId;
  final String? userName;
  final int rating;
  final String? comment;
  final List<String> photos;
  final String? businessReply;
  final DateTime? businessRepliedAt;
  final bool isReported;
  final bool isApproved;
  final DateTime createdAt;

  factory BusinessReview.fromJson(Map<String, dynamic> json) {
    return BusinessReview(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String?,
      photos: (json['photos'] as List<dynamic>? ?? []).map((x) => x.toString()).toList(),
      businessReply: json['businessReply'] as String?,
      businessRepliedAt: json['businessRepliedAt'] == null
          ? null
          : DateTime.tryParse(json['businessRepliedAt'].toString()),
      isReported: json['isReported'] as bool? ?? false,
      isApproved: json['isApproved'] as bool? ?? true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class BusinessReviewSummary {
  const BusinessReviewSummary({
    required this.businessId,
    required this.averageRating,
    required this.totalReviews,
    required this.fiveStars,
    required this.fourStars,
    required this.threeStars,
    required this.twoStars,
    required this.oneStar,
  });

  final String businessId;
  final num averageRating;
  final int totalReviews;
  final int fiveStars;
  final int fourStars;
  final int threeStars;
  final int twoStars;
  final int oneStar;

  factory BusinessReviewSummary.fromJson(Map<String, dynamic> json) {
    return BusinessReviewSummary(
      businessId: json['businessId'] as String,
      averageRating: json['averageRating'] as num? ?? 0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      fiveStars: json['fiveStars'] as int? ?? 0,
      fourStars: json['fourStars'] as int? ?? 0,
      threeStars: json['threeStars'] as int? ?? 0,
      twoStars: json['twoStars'] as int? ?? 0,
      oneStar: json['oneStar'] as int? ?? 0,
    );
  }
}
