import 'package:flutter/material.dart';

import '../tokens/piyi_colors.dart';
import '../tokens/piyi_spacing.dart';
import 'piyi_card.dart';

class PiyiAlertCard extends StatelessWidget {
  const PiyiAlertCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PiyiCard(
      onTap: onTap,
      padding: const EdgeInsets.all(PiyiSpacing.lg),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFFFE8EC),
            child: Icon(Icons.location_on, color: PiyiColors.error),
          ),
          const SizedBox(width: PiyiSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(subtitle),
              ],
            ),
          ),
          if (actionLabel != null)
            Text(
              actionLabel!,
              style: const TextStyle(
                color: PiyiColors.error,
                fontWeight: FontWeight.w900,
              ),
            ),
        ],
      ),
    );
  }
}
