import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:piyi_ui/piyi_ui.dart';

import 'map_controller.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  static const route = '/map';

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _controller;

  static const _cartago = LatLng(9.8644, -83.9194);

  Future<void> _centerOnMe() async {
    final position = await ref.read(currentPositionProvider.future);

    if (position == null || _controller == null) {
      if (mounted) {
        PiyiSnackBar.warning(context, 'No pudimos obtener tu ubicación.');
      }
      return;
    }

    await _controller!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final positionAsync = ref.watch(currentPositionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Piyí'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(currentPositionProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerOnMe,
        child: const Icon(Icons.my_location),
      ),
      body: positionAsync.when(
        data: (position) {
          final initial = position == null
              ? _cartago
              : LatLng(position.latitude, position.longitude);

          return GoogleMap(
            initialCameraPosition: CameraPosition(target: initial, zoom: 14),
            myLocationEnabled: position != null,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => _controller = controller,
          );
        },
        error: (error, _) => SafeArea(
          minimum: const EdgeInsets.all(PiyiSpacing.md),
          child: PiyiEmptyState(
            icon: Icons.location_off,
            title: 'No pudimos abrir el mapa',
            message: error.toString(),
            actionLabel: 'Reintentar',
            onAction: () => ref.invalidate(currentPositionProvider),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
