import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../core/config/app_config.dart';
import 'app_router.dart';

class PiyiApp extends ConsumerWidget {
  const PiyiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConfig.displayName,
      debugShowCheckedModeBanner: false,
      theme: PiyiTheme.light,
      darkTheme: PiyiTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
