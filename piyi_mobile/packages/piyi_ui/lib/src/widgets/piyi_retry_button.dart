import 'package:flutter/material.dart';

import 'piyi_button.dart';

class PiyiRetryButton extends StatelessWidget {
  const PiyiRetryButton({
    super.key,
    required this.onRetry,
    this.label = 'Reintentar',
  });

  final VoidCallback onRetry;
  final String label;

  @override
  Widget build(BuildContext context) {
    return PiyiSecondaryButton(
      label: label,
      icon: Icons.refresh,
      onPressed: onRetry,
    );
  }
}
