class ApiConfig {
  // Desarrollo recomendado con celular físico conectado por USB:
  // Ejecutar antes:
  // adb reverse tcp:5105 tcp:5105
  static const String baseUrl = 'http://127.0.0.1:5105';

  // Alternativa por Wi-Fi:
  // static const String baseUrl = 'http://10.28.28.228:5105';

  // Android emulator:
  // static const String baseUrl = 'http://10.0.2.2:5105';
}
