import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app/piyi_app.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Piyí FlutterError: ${details.exception}');
    };

    runApp(
      const ProviderScope(
        child: PiyiApp(),
      ),
    );
  }, (Object error, StackTrace stackTrace) {
    debugPrint('Piyí startup error: $error');
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
                  'No pudimos iniciar Piyí. Cerrá la app e intentá nuevamente.',
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