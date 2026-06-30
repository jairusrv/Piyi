import 'package:flutter/material.dart';

import '../tokens/piyi_spacing.dart';

class PiyiActivityItem {
  const PiyiActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
}

class PiyiActivityTimeline extends StatelessWidget {
  const PiyiActivityTimeline({
    super.key,
    required this.items,
  });

  final List<PiyiActivityItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          _TimelineRow(
            item: items[i],
            isLast: i == items.length - 1,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.item,
    required this.isLast,
  });

  final PiyiActivityItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: item.color.withOpacity(0.14),
                child: Icon(item.icon, color: item.color, size: 18),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: item.color.withOpacity(0.15),
                  ),
                ),
            ],
          ),
          const SizedBox(width: PiyiSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: PiyiSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
