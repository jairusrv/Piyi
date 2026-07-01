import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:piyi_ui/piyi_ui.dart';

class PiyiCurrentLocationCard extends StatelessWidget {
  const PiyiCurrentLocationCard({
    super.key,
    required this.position,
    this.title = 'Ubicación actual',
  });

  final Position position;
  final String title;

  @override
  Widget build(BuildContext context) {
    return PiyiCard(
      child: Row(
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
                const SizedBox(height: 3),
                Text(
                  'Lat: ${position.latitude.toStringAsFixed(6)} · Lng: ${position.longitude.toStringAsFixed(6)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
