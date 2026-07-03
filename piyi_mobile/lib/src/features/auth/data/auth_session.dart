class AuthSession {
  const AuthSession({
    required this.accessToken,
    this.refreshToken,
    this.userId,
    this.email,
    this.savedAt,
  });

  final String accessToken;
  final String? refreshToken;
  final String? userId;
  final String? email;
  final DateTime? savedAt;

  bool get isValid => accessToken.trim().isNotEmpty;
}
