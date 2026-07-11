import 'package:flutter/material.dart';

import '../tokens/piyi_colors.dart';
import '../tokens/piyi_spacing.dart';
import 'piyi_button.dart';

class PiyiFriendlyEmptyState extends StatelessWidget {
  const PiyiFriendlyEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.color = PiyiColors.primary,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PiyiSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 46),
            ),
            const SizedBox(height: PiyiSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: PiyiSpacing.sm),
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: PiyiSpacing.lg),
              PiyiPrimaryButton(
                label: actionLabel!,
                icon: Icons.arrow_forward,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
