import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app/piyi_app.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('PiyÃ­ FlutterError: ${details.exception}');
    };

    runApp(
      const ProviderScope(
        child: PiyiApp(),
      ),
    );
  }, (Object error, StackTrace stackTrace) {
    debugPrint('PiyÃ­ startup error: $error');
    debugPrintStack(stackTrace: stackTrace);

    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No pudimos iniciar PiyÃ­. CerrÃ¡ la app e intentÃ¡ nuevamente.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });
}