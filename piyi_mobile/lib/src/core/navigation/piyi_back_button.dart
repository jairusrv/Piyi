import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PiyiBackButton extends StatelessWidget {
  const PiyiBackButton({
    super.key,
    this.fallbackRoute = '/home',
  });

  final String fallbackRoute;

  static Widget fallbackHome(BuildContext context) {
    return const PiyiBackButton(fallbackRoute: '/home');
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
