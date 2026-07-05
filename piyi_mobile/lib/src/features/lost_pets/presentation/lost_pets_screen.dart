import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
import 'lost_pet_detail_screen.dart';
import 'lost_pets_controller.dart';

class LostPetsScreen extends ConsumerWidget {
  const LostPetsScreen({super.key});

  static const route = '/lost-pets';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lostPetsAsync = ref.watch(lostPetsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mascotas perdidas'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(lostPetsListProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(PiyiSpacing.md),
        child: Column(
          children: [
            PiyiBannerCard(
              icon: Icons.location_on,
              title: 'Ayudemos a encontrarlas',
              subtitle: 'Reportes activos de la comunidad. Si viste una, abre el reporte y avisa.',
              color: PiyiColors.error,
            ),
            const SizedBox(height: PiyiSpacing.md),
            PiyiTile(
              icon: Icons.info_outline,
              title: 'Flujo simple',
              subtitle: 'Publicar, ver detalles, reportar avistamiento y contactar.',
              color: PiyiColors.info,
            ),
            const SizedBox(height: PiyiSpacing.md),
            Expanded(
              child: lostPetsAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return PiyiEmptyState(
                      icon: Icons.pets,
                      title: 'No hay reportes activos',
                      message: 'Cuando una mascota sea reportada como perdida aparecerá aquí.',
                      actionLabel: 'Actualizar',
                      onAction: () => ref.invalidate(lostPetsListProvider),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(lostPetsListProvider),
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: PiyiSpacing.sm),
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return PiyiCard(
                          onTap: () => context.go(LostPetDetailScreen.path(item.id)),
                          child: Row(
                            children: [
                              PiyiAvatar(
                                imageUrl: item.petPhotoUrl,
                                name: item.petName,
                                size: 64,
                                icon: Icons.pets,
                              ),
                              const SizedBox(width: PiyiSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.petName.isEmpty ? item.title : item.petName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        const PiyiBadge(label: 'Perdida', color: PiyiColors.error),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.lastSeenAddress ?? 'Ubicación no indicada',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, _) => PiyiEmptyState(
                  icon: Icons.error_outline,
                  title: 'No pudimos cargar reportes',
                  message: ApiErrorMessage.fromObject(error),
                  actionLabel: 'Reintentar',
                  onAction: () => ref.invalidate(lostPetsListProvider),
                ),
                loading: () => const PiyiLoadingList(itemCount: 5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
