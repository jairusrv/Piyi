import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../current_location_controller.dart';

class PiyiUseCurrentLocationButton extends ConsumerWidget {
  const PiyiUseCurrentLocationButton({
    super.key,
    required this.onLocation,
    this.label = 'Usar mi ubicación actual',
  });

  final ValueChanged<Position> onLocation;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PiyiSecondaryButton(
      label: label,
      icon: Icons.my_location,
      onPressed: () async {
        final position = await ref.read(currentLocationProvider.future);

        if (position == null) {
          if (context.mounted) {
            PiyiSnackBar.warning(
              context,
              'No pudimos obtener tu ubicación. Revisa permisos y GPS.',
            );
          }
          return;
        }

        onLocation(position);
      },
    );
  }
}
