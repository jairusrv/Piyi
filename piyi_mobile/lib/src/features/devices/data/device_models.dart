class UserDevice {
  UserDevice({
    required this.id,
    required this.deviceIdentifier,
    required this.platform,
    this.deviceName,
    this.appVersion,
    required this.isActive,
    this.lastSeenAt,
    required this.createdAt,
  });

  final String id;
  final String deviceIdentifier;
  final String platform;
  final String? deviceName;
  final String? appVersion;
  final bool isActive;
  final String? lastSeenAt;
  final String createdAt;

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
      id: json['id'] as String,
      deviceIdentifier: json['deviceIdentifier'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      deviceName: json['deviceName'] as String?,
      appVersion: json['appVersion'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      lastSeenAt: json['lastSeenAt'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}
