import 'package:flutter/material.dart';
import 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/utils/external_launcher.dart';
import '../../businesses/presentation/business_detail_screen.dart';
import '../../lost_pets/presentation/lost_pet_detail_screen.dart';
import 'map_cache_controller.dart';
import 'map_controller.dart';
import 'map_filter_controller.dart';
import 'map_markers_controller.dart';
import 'widgets/piyi_map_filter_sheet.dart';
import 'widgets/piyi_marker_bottom_sheet.dart';

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
      if (mounted) PiyiSnackBar.warning(context, 'No pudimos obtener tu ubicaciÃƒÆ’Ã‚Â³n.');
      return;
    }

    await _controller!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 15),
    );
  }

  void _refreshMap() {
    ref.invalidate(lostPetMapMarkersProvider);
    ref.invalidate(businessMapMarkersProvider);
    ref.read(mapLastRefreshProvider.notifier).state = DateTime.now();
    PiyiSnackBar.success(context, 'Mapa actualizado.');
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => const PiyiMapFilterSheet(),
    );
  }

  Future<void> _navigateTo(num latitude, num longitude, String label) async {
    try {
      await ExternalLauncher.openMaps(
        latitude: latitude,
        longitude: longitude,
        query: label,
      );
    } catch (_) {
      if (mounted) PiyiSnackBar.error(context, 'No se pudo abrir Google Maps.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final positionAsync = ref.watch(currentPositionProvider);
    final lostPetsAsync = ref.watch(lostPetMapMarkersProvider);
    final businessesAsync = ref.watch(businessMapMarkersProvider);
    final filter = ref.watch(mapLayerFilterProvider);
    final lastRefresh = ref.watch(mapLastRefreshProvider);

    return Scaffold(
      appBar: AppBar(
        leading: PiyiAppBackButton.fallbackHome(context),
        title: const Text('Mapa PiyÃƒÆ’Ã‚Â­'),
        actions: [
          IconButton(onPressed: _openFilters, icon: const Icon(Icons.filter_alt)),
          IconButton(onPressed: _refreshMap, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerOnMe,
        child: const Icon(Icons.my_location),
      ),
      body: positionAsync.when(
        data: (position) {
          final initial = position == null ? _cartago : LatLng(position.latitude, position.longitude);
          final markers = <Marker>{};

          if (filter == MapLayerFilter.all || filter == MapLayerFilter.lostPets) {
            lostPetsAsync.whenData((items) {
              for (final item in items) {
                markers.add(
                  Marker(
                    markerId: MarkerId('lost-${item.id}'),
                    position: LatLng(item.latitude.toDouble(), item.longitude.toDouble()),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (_) => PiyiMarkerBottomSheet(
                        title: item.petName.isEmpty ? 'Mascota perdida' : item.petName,
                        subtitle: item.lastSeenAddress ?? item.title,
                        icon: Icons.location_on,
                        color: PiyiColors.error,
                        onDetails: () {
                          Navigator.pop(context);
                          context.go(LostPetDetailScreen.path(item.id));
                        },
                        onNavigate: () => _navigateTo(item.latitude, item.longitude, item.petName),
                      ),
                    ),
                  ),
                );
              }
            });
          }

          if (filter == MapLayerFilter.all || filter == MapLayerFilter.businesses) {
            businessesAsync.whenData((items) {
              for (final item in items) {
                markers.add(
                  Marker(
                    markerId: MarkerId('business-${item.id}'),
                    position: LatLng(item.latitude.toDouble(), item.longitude.toDouble()),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (_) => PiyiMarkerBottomSheet(
                        title: item.name,
                        subtitle: item.businessTypeName ?? item.address ?? 'Negocio',
                        icon: Icons.store,
                        color: PiyiColors.secondary,
                        onDetails: () {
                          Navigator.pop(context);
                          context.go(BusinessDetailScreen.path(item.id));
                        },
                        onNavigate: () => _navigateTo(item.latitude, item.longitude, item.name),
                      ),
                    ),
                  ),
                );
              }
            });
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: initial, zoom: 13),
                myLocationEnabled: position != null,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: markers,
                onMapCreated: (controller) => _controller = controller,
              ),
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: PiyiCard(
                  padding: const EdgeInsets.all(PiyiSpacing.sm),
                  child: Row(
                    children: [
                      const Icon(Icons.map),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          lastRefresh == null
                              ? 'Mostrando ${markers.length} puntos'
                              : 'Mostrando ${markers.length} puntos Ãƒâ€šÃ‚Â· actualizado',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
