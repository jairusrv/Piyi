import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pets_controller.dart';

class PetDetailScreen extends ConsumerWidget {
  const PetDetailScreen({
    super.key,
    required this.petId,
  });

  static const route = '/pets/:id';

  static String path(String id) => '/pets/$id';

  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petDetailProvider(petId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de mascota'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: petAsync.when(
          data: (pet) => ListView(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  child: Text(
                    pet.name.isEmpty ? '🐾' : pet.name[0],
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                pet.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 24),
              _InfoRow(label: 'Especie', value: pet.speciesName),
              _InfoRow(label: 'Raza', value: pet.breedName ?? 'No indicada'),
              _InfoRow(label: 'Color', value: pet.color ?? 'No indicado'),
              _InfoRow(label: 'Sexo', value: pet.sex),
              _InfoRow(
                label: 'Peso',
                value: pet.weightKg == null ? 'No indicado' : '${pet.weightKg} kg',
              ),
              _InfoRow(
                label: 'Esterilizada/o',
                value: pet.isSterilized ? 'Sí' : 'No',
              ),
              _InfoRow(label: 'Estado', value: pet.status),
            ],
          ),
          error: (error, _) => Center(
            child: Text('Error cargando mascota: $error'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(label),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
