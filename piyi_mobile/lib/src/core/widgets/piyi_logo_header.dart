import 'package:flutter/material.dart';

import '../brand/piyi_brand.dart';

class PiyiLogoHeader extends StatelessWidget {
  const PiyiLogoHeader({
    super.key,
    this.width = 230,
    this.showSlogan = false,
  });

  final double width;
  final bool showSlogan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          PiyiBrand.logoAsset,
          width: width,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          isAntiAlias: true,
        ),
        if (showSlogan) ...[
          const SizedBox(height: 8),
          Text(
            PiyiBrand.slogan,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF31A997),
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ],
    );
  }
}
