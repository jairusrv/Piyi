import 'package:flutter/material.dart';

import '../tokens/piyi_colors.dart';
import '../tokens/piyi_spacing.dart';
import 'piyi_button.dart';

class PiyiErrorView extends StatelessWidget {
  const PiyiErrorView({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel = 'Reintentar',
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PiyiSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: PiyiColors.error.withOpacity(0.12),
              child: Icon(icon, size: 42, color: PiyiColors.error),
            ),
            const SizedBox(height: PiyiSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: PiyiSpacing.sm),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: PiyiSpacing.lg),
              PiyiPrimaryButton(
                label: actionLabel,
                icon: Icons.refresh,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
