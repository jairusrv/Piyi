class ApiConfig {
  const ApiConfig._();

  static const String defaultBaseUrl = 'https://piyi.onrender.com';

  static const String baseUrl = String.fromEnvironment(
    'PIYI_API_BASE_URL',
    defaultValue: defaultBaseUrl,
  );
}
