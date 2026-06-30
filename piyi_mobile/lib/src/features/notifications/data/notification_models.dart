class UserNotification {
  UserNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.dataJson,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String title;
  final String body;
  final String? dataJson;
  final bool isRead;
  final String? readAt;
  final String createdAt;

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'] as String,
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      dataJson: json['dataJson'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}
