class AppConfig {
  const AppConfig._();

  static const technicalName = 'Piyi';
  static const displayName = 'Piyí';

  static const enableDevTools = bool.fromEnvironment(
    'PIYI_ENABLE_DEV_TOOLS',
    defaultValue: false,
  );
}
