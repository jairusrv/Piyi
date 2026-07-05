class ApiConfig {
  const ApiConfig._();

  static const baseUrl = String.fromEnvironment(
    'PIYI_API_BASE_URL',
    defaultValue: 'https://piyi.onrender.com',
  );

  static bool get isLocalApi =>
      baseUrl.contains('127.0.0.1') ||
      baseUrl.contains('localhost') ||
      baseUrl.contains('10.0.2.2');
}
