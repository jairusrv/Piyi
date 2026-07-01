import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';

class PiyiNavigationHelper {
  const PiyiNavigationHelper._();

  static void backOrHome(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    context.go(HomeScreen.route);
  }

  static void backOr(BuildContext context, String route) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    context.go(route);
  }
}
