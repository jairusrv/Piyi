import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../data/current_location_result.dart';
import '../current_location_controller.dart';

class PiyiUseCurrentLocationButton extends ConsumerWidget {
  const PiyiUseCurrentLocationButton({
    super.key,
    required this.onLocation,
    this.label = 'Usar mi ubicación actual',
  });

  final ValueChanged<CurrentLocationResult> onLocation;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PiyiSecondaryButton(
      label: label,
      icon: Icons.my_location,
      onPressed: () async {
        final location = await ref.read(currentLocationProvider.future);

        if (location == null) {
          if (context.mounted) {
            PiyiSnackBar.warning(
              context,
              'No pudimos obtener tu ubicación. Activa GPS y permisos.',
            );
          }
          return;
        }

        ref.read(selectedCurrentLocationProvider.notifier).state = location;
        onLocation(location);

        if (context.mounted) {
          PiyiSnackBar.success(context, 'Ubicación obtenida correctamente.');
        }
      },
    );
  }
}
