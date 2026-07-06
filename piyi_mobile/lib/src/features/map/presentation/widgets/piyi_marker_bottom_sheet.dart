import 'package:flutter/material.dart';
import 'package:piyi_ui/piyi_ui.dart';

class PiyiMarkerBottomSheet extends StatelessWidget {
  const PiyiMarkerBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onDetails,
    this.onNavigate,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onDetails;
  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(PiyiSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PiyiCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: color.withValues(alpha: 0.14),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: PiyiSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(subtitle),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: PiyiSpacing.md),
          PiyiPrimaryButton(
            label: 'Ver detalles',
            icon: Icons.open_in_new,
            onPressed: onDetails,
          ),
          if (onNavigate != null) ...[
            const SizedBox(height: PiyiSpacing.sm),
            PiyiSecondaryButton(
              label: 'Cómo llegar',
              icon: Icons.directions,
              onPressed: onNavigate,
            ),
          ],
        ],
      ),
    );
  }
}
