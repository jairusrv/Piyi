import 'package:flutter/material.dart';

import '../tokens/piyi_spacing.dart';
import 'piyi_dashboard_card.dart';

class PiyiQuickActionItem {
  const PiyiQuickActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.badge,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String? badge;
  final VoidCallback? onTap;
}

class PiyiQuickActionGrid extends StatelessWidget {
  const PiyiQuickActionGrid({
    super.key,
    required this.items,
  });

  final List<PiyiQuickActionItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: PiyiSpacing.md,
        mainAxisSpacing: PiyiSpacing.md,
        childAspectRatio: 1.08,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return PiyiDashboardCard(
          icon: item.icon,
          title: item.title,
          subtitle: item.subtitle,
          color: item.color,
          badge: item.badge,
          onTap: item.onTap,
        );
      },
    );
  }
}
