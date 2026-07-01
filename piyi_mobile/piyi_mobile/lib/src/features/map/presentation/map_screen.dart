import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../businesses/presentation/business_detail_screen.dart';
import '../../lost_pets/presentation/lost_pet_detail_screen.dart';
import 'map_controller.dart';
import 'map_markers_controller.dart';

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
    if (position == null || _controller == null) return;

    await _controller!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    final positionAsync = ref.watch(currentPositionProvider);
    final lostPetsAsync = ref.watch(lostPetMapMarkersProvider);
    final businessesAsync = ref.watch(businessMapMarkersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa Piyí')),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerOnMe,
        child: const Icon(Icons.my_location),
      ),
      body: positionAsync.when(
        data: (position) {
          final initial = position == null ? _cartago : LatLng(position.latitude, position.longitude);
          final markers = <Marker>{};

          lostPetsAsync.whenData((items) {
            for (final item in items) {
              markers.add(
                Marker(
                  markerId: MarkerId('lost-${item.id}'),
                  position: LatLng(item.latitude.toDouble(), item.longitude.toDouble()),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  infoWindow: InfoWindow(
                    title: item.petName.isEmpty ? 'Mascota perdida' : item.petName,
                    snippet: item.lastSeenAddress ?? item.title,
                    onTap: () => context.go(LostPetDetailScreen.path(item.id)),
                  ),
                ),
              );
            }
          });

          businessesAsync.whenData((items) {
            for (final item in items) {
              markers.add(
                Marker(
                  markerId: MarkerId('business-${item.id}'),
                  position: LatLng(item.latitude.toDouble(), item.longitude.toDouble()),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                  infoWindow: InfoWindow(
                    title: item.name,
                    snippet: item.businessTypeName ?? item.address ?? 'Negocio',
                    onTap: () => context.go(BusinessDetailScreen.path(item.id)),
                  ),
                ),
              );
            }
          });

          return GoogleMap(
            initialCameraPosition: CameraPosition(target: initial, zoom: 13),
            myLocationEnabled: position != null,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: markers,
            onMapCreated: (controller) => _controller = controller,
          );
        },
        error: (error, _) => PiyiEmptyState(
          icon: Icons.map,
          title: 'No pudimos abrir el mapa',
          message: '$error',
          actionLabel: 'Reintentar',
          onAction: () => ref.invalidate(currentPositionProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
