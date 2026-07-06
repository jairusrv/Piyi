import 'package:flutter/material.dart';
import '../../core/navigation/piyi_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
import 'create_pet_screen.dart';
import 'pet_detail_screen.dart';
import 'pets_controller.dart';

class PetsScreen extends ConsumerWidget {
  const PetsScreen({super.key});

  static const route = '/pets';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: PiyiBackButton.fallbackHome(context),
        title: const Text('Mis mascotas'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(petsProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(CreatePetScreen.route),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(PiyiSpacing.md),
        child: petsAsync.when(
          data: (pets) {
            if (pets.isEmpty) {
              return PiyiEmptyState(
                icon: Icons.pets,
                title: 'AÃºn no tienes mascotas',
                message: 'Registra tu primera mascota para gestionar su salud, QR, recordatorios y alertas.',
                actionLabel: 'Registrar mascota',
                onAction: () => context.go(CreatePetScreen.route),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(petsProvider),
              child: ListView.separated(
                itemCount: pets.length,
                separatorBuilder: (_, __) => const SizedBox(height: PiyiSpacing.sm),
                itemBuilder: (context, index) {
                  final pet = pets[index];

                  return PiyiCard(
                    onTap: () => context.go(PetDetailScreen.path(pet.id)),
                    padding: const EdgeInsets.all(PiyiSpacing.md),
                    child: Row(
                      children: [
                        PiyiAvatar(
                          imageUrl: pet.photoUrl,
                          name: pet.name,
                          size: 62,
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
                                      pet.name,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  PiyiBadge(label: pet.status),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${pet.speciesName}${pet.breedName == null ? '' : ' Â· ${pet.breedName}'}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pet.color == null || pet.color!.isEmpty ? 'Color no indicado' : pet.color!,
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
            title: 'No pudimos cargar tus mascotas',
            message: ApiErrorMessage.fromObject(error),
            actionLabel: 'Reintentar',
            onAction: () => ref.invalidate(petsProvider),
          ),
          loading: () => const PiyiLoadingList(itemCount: 5),
        ),
      ),
    );
  }
}
