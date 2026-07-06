import 'package:flutter/material.dart';

import '../tokens/piyi_colors.dart';
import '../tokens/piyi_spacing.dart';
import 'piyi_card.dart';

class PiyiReminderCard extends StatelessWidget {
  const PiyiReminderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    this.icon = Icons.event,
    this.color = PiyiColors.warning,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String dateLabel;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PiyiCard(
      onTap: onTap,
      padding: const EdgeInsets.all(PiyiSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(icon, color: color),
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
          Text(
            dateLabel,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
