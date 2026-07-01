import 'package:flutter/material.dart';

import '../tokens/piyi_colors.dart';

class PiyiSnackBar {
  const PiyiSnackBar._();

  static void success(BuildContext context, String message) {
    _show(context, message, PiyiColors.success, Icons.check_circle);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, PiyiColors.error, Icons.error);
  }

  static void warning(BuildContext context, String message) {
    _show(context, message, PiyiColors.warning, Icons.warning);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, PiyiColors.info, Icons.info);
  }

  static void _show(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
