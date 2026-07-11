import 'package:flutter/material.dart';
import 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
import 'lost_pet_sightings_controller.dart';
import 'lost_pets_controller.dart';
import 'report_sighting_screen.dart';

class LostPetDetailScreen extends ConsumerWidget {
  const LostPetDetailScreen({super.key, required this.lostPetId});

  static const route = '/lost-pets/:id';
  static String path(String id) => '/lost-pets/$id';

  final String lostPetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(lostPetDetailProvider(lostPetId));
    final sightingsAsync = ref.watch(lostPetSightingsProvider(lostPetId));

    return Scaffold(
      appBar: AppBar(
        leading: PiyiAppBackButton.fallbackHome(context),
        title: const Text('Reporte')),
      body: SafeArea(
        minimum: const EdgeInsets.all(PiyiSpacing.md),
        child: detailAsync.when(
          data: (report) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(lostPetDetailProvider(lostPetId));
              ref.invalidate(lostPetSightingsProvider(lostPetId));
            },
            child: ListView(
              children: [
                PiyiBannerCard(
                  icon: Icons.location_on,
                  title: report.petName.isEmpty ? 'Mascota perdida' : report.petName,
                  subtitle: report.lastSeenAddress ?? 'ÃƒÆ’Ã…¡ltima ubicaciÃƒÆ’Ã‚Â³n no indicada',
                  color: PiyiColors.error,
                ),
                const SizedBox(height: PiyiSpacing.md),
                PiyiCard(
                  child: Column(
                    children: [
                      PiyiAvatar(
                        imageUrl: report.petPhotoUrl,
                        name: report.petName,
                        size: 92,
                        icon: Icons.pets,
                      ),
                      const SizedBox(height: PiyiSpacing.md),
                      Text(
                        report.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: PiyiSpacing.xs),
                      Text(
                        '${report.speciesName}${report.breedName == null ? '' : ' Ãƒâ€šÃ‚Â· ${report.breedName}'}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: PiyiSpacing.sm),
                      const PiyiBadge(label: 'Reporte activo', color: PiyiColors.error),
                    ],
                  ),
                ),
                const SizedBox(height: PiyiSpacing.md),
                PiyiSection(
                  title: 'InformaciÃƒÆ’Ã‚Â³n del reporte',
                  child: Column(
                    children: [
                      PiyiTile(
                        icon: Icons.campaign,
                        title: 'DescripciÃƒÆ’Ã‚Â³n',
                        subtitle: report.description,
                        color: PiyiColors.error,
                      ),
                      const SizedBox(height: PiyiSpacing.sm),
                      PiyiTile(
                        icon: Icons.location_on,
                        title: 'ÃƒÆ’Ã…¡ltimo lugar visto',
                        subtitle: report.lastSeenAddress ?? 'No indicado',
                        color: PiyiColors.error,
                      ),
                      const SizedBox(height: PiyiSpacing.sm),
                      PiyiTile(
                        icon: Icons.color_lens,
                        title: 'Color',
                        subtitle: report.color ?? 'No indicado',
                        color: PiyiColors.primary,
                      ),
                      const SizedBox(height: PiyiSpacing.sm),
                      PiyiTile(
                        icon: Icons.phone,
                        title: 'Contacto',
                        subtitle: report.contactPhone ?? 'No indicado',
                        color: PiyiColors.secondary,
                      ),
                      const SizedBox(height: PiyiSpacing.sm),
                      PiyiTile(
                        icon: Icons.card_giftcard,
                        title: 'Recompensa',
                        subtitle: report.rewardAmount == null ? 'No indicada' : 'ÃƒÂ¢Ã¢â‚¬Å¡Ã‚¡${report.rewardAmount}',
                        color: PiyiColors.warning,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: PiyiSpacing.md),
                PiyiPrimaryButton(
                  label: 'Creo que la vi',
                  icon: Icons.visibility,
                  onPressed: () => context.go(ReportSightingScreen.path(lostPetId)),
                ),
                const SizedBox(height: PiyiSpacing.xl),
                PiyiSection(
                  title: 'Avistamientos',
                  child: sightingsAsync.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return const PiyiEmptyState(
                          icon: Icons.visibility_off,
                          title: 'Sin avistamientos',
                          message: 'AÃƒÆ’Ã‚Âºn nadie ha reportado haber visto esta mascota.',
                        );
                      }

                      return Column(
                        children: items.map((sighting) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: PiyiSpacing.sm),
                            child: PiyiTile(
                              icon: Icons.place,
                              title: sighting.address ?? 'UbicaciÃƒÆ’Ã‚Â³n reportada',
                              subtitle:
                                  '${sighting.observation ?? 'Sin observaciÃƒÆ’Ã‚Â³n'}\nLat: ${sighting.latitude}, Lng: ${sighting.longitude}',
                              color: PiyiColors.error,
                            ),
                          );
                        }).toList(),
                      );
                    },
                    error: (error, _) => PiyiEmptyState(
                      icon: Icons.error_outline,
                      title: 'No pudimos cargar avistamientos',
                      message: ApiErrorMessage.fromObject(error),
                      actionLabel: 'Reintentar',
                      onAction: () => ref.invalidate(lostPetSightingsProvider(lostPetId)),
                    ),
                    loading: () => const PiyiLoadingList(itemCount: 3),
                  ),
                ),
              ],
            ),
          ),
          error: (error, _) => PiyiEmptyState(
            icon: Icons.error_outline,
            title: 'No pudimos cargar el reporte',
            message: ApiErrorMessage.fromObject(error),
            actionLabel: 'Reintentar',
            onAction: () => ref.invalidate(lostPetDetailProvider(lostPetId)),
          ),
          loading: () => const PiyiLoadingList(itemCount: 5),
        ),
      ),
    );
  }
}
