import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static Future<bool> tryInitialize() async {
    const enabled = bool.fromEnvironment(
      'PIYI_ENABLE_FIREBASE',
      defaultValue: false,
    );

    if (!enabled) {
      debugPrint('PiyÃ­ Firebase disabled for beta startup.');
      return false;
    }

    try {
      if (Firebase.apps.isNotEmpty) {
        return true;
      }

      await Firebase.initializeApp();
      debugPrint('PiyÃ­ Firebase initialized.');
      return true;
    } catch (error, stackTrace) {
      debugPrint('PiyÃ­ Firebase initialization skipped: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }
}