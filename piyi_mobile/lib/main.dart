import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app/piyi_app.dart';
import 'src/core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseBootstrap.tryInitialize();

  runApp(
    const ProviderScope(
      child: PiyiApp(),
    ),
  );
}
