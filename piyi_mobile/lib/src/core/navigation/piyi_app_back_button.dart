import 'package:flutter/material.dart';
import 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';
import 'package:go_router/go_router.dart';

class PiyiAppBackButton extends StatelessWidget {
  const PiyiAppBackButton({
    super.key,
    this.fallbackRoute = '/home',
  });

  final String fallbackRoute;

  static Widget fallbackHome(BuildContext context) {
    return const PiyiAppBackButton(fallbackRoute: '/home');
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Volver',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        final navigator = Navigator.of(context);

        if (navigator.canPop()) {
          navigator.pop();
          return;
        }

        context.go(fallbackRoute);
      },
    );
  }
}
