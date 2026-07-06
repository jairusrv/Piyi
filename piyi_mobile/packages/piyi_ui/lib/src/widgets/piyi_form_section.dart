import 'package:flutter/material.dart';

import '../tokens/piyi_spacing.dart';
import 'piyi_card.dart';

class PiyiFormSection extends StatelessWidget {
  const PiyiFormSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return PiyiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subtitle!),
          ],
          const SizedBox(height: PiyiSpacing.md),
          ...children,
        ],
      ),
    );
  }
}
