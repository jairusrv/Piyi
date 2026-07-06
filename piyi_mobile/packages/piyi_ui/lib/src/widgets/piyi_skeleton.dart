import 'package:flutter/material.dart';

import '../tokens/piyi_radius.dart';
import '../tokens/piyi_spacing.dart';

class PiyiSkeleton extends StatefulWidget {
  const PiyiSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = PiyiRadius.md,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<PiyiSkeleton> createState() => _PiyiSkeletonState();
}

class _PiyiSkeletonState extends State<PiyiSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 0.8).animate(_controller),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

class PiyiSkeletonCard extends StatelessWidget {
  const PiyiSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(PiyiSpacing.md),
        child: Row(
          children: [
            PiyiSkeleton(width: 62, height: 62, borderRadius: 32),
            SizedBox(width: PiyiSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PiyiSkeleton(width: 180, height: 18),
                  SizedBox(height: PiyiSpacing.sm),
                  PiyiSkeleton(width: double.infinity, height: 14),
                  SizedBox(height: PiyiSpacing.xs),
                  PiyiSkeleton(width: 130, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PiyiSkeletonList extends StatelessWidget {
  const PiyiSkeletonList({
    super.key,
    this.itemCount = 5,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: PiyiSpacing.sm),
      itemBuilder: (_, __) => const PiyiSkeletonCard(),
    );
  }
}
