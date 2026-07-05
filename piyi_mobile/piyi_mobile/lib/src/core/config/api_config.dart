class ApiConfig {
  const ApiConfig._();

  static const baseUrl = String.fromEnvironment(
    'PIYI_API_BASE_URL',
    defaultValue: 'https://piyi.onrender.com',
  );
}
