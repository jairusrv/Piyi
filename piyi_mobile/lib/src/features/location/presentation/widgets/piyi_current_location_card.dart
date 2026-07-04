import 'package:flutter/material.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../data/current_location_result.dart';

class PiyiCurrentLocationCard extends StatelessWidget {
  const PiyiCurrentLocationCard({
    super.key,
    required this.location,
    this.title = 'Ubicación actual',
  });

  final CurrentLocationResult location;
  final String title;

  @override
  Widget build(BuildContext context) {
    return PiyiCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE9F9F1),
            child: Icon(Icons.my_location, color: PiyiColors.primary),
          ),
          const SizedBox(width: PiyiSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(location.placeLabel),
                const SizedBox(height: 4),
                Text(location.accuracyLabel, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(location.coordinatesLabel, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
