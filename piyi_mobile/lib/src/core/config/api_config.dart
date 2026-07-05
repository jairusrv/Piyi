class ApiConfig {
  const ApiConfig._();

  static const baseUrl = String.fromEnvironment(
    'PIYI_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5105',
  );

  static bool get isLocalApi =>
      baseUrl.contains('127.0.0.1') ||
      baseUrl.contains('localhost') ||
      baseUrl.contains('10.0.2.2');
}
