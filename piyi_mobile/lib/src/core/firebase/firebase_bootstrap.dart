import 'package:firebase_core/firebase_core.dart';

class FirebaseBootstrap {
  static bool isInitialized = false;

  static Future<void> tryInitialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        isInitialized = true;
        return;
      }

      await Firebase.initializeApp();
      isInitialized = true;
    } catch (_) {
      // Firebase todavía no está configurado.
      // Mantendremos la app funcionando con token DEV.
      isInitialized = false;
    }
  }
}
