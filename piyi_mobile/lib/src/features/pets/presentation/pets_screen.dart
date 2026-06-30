import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'create_pet_screen.dart';
import 'pet_detail_screen.dart';
import 'pets_controller.dart';

class PetsScreen extends ConsumerWidget {
  const PetsScreen({super.key});

  static const route = '/pets';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis mascotas'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(CreatePetScreen.route),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: petsAsync.when(
          data: (pets) {
            if (pets.isEmpty) {
              return const Center(
                child: Text(
                  'Aún no tienes mascotas registradas.\nAgrega la primera 🐾',
                  textAlign: TextAlign.center,
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(petsListProvider);
              },
              child: ListView.builder(
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(pet.name.isEmpty ? '🐾' : pet.name[0]),
                      ),
                      title: Text(
                        pet.name,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        '${pet.speciesName}${pet.breedName == null ? '' : ' · ${pet.breedName}'}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go(PetDetailScreen.path(pet.id)),
                    ),
                  );
                },
              ),
            );
          },
          error: (error, _) => Center(
            child: Text('Error cargando mascotas: $error'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
