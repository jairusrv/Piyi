import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lost_pets_controller.dart';

class LostPetDetailScreen extends ConsumerWidget {
  const LostPetDetailScreen({super.key, required this.lostPetId});

  static const route = '/lost-pets/:id';
  static String path(String id) => '/lost-pets/$id';

  final String lostPetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(lostPetDetailProvider(lostPetId));

    return Scaffold(
      appBar: AppBar(title: const Text('Reporte')),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: detailAsync.when(
          data: (report) => ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: report.petPhotoUrl == null ? null : NetworkImage(report.petPhotoUrl!),
                        child: report.petPhotoUrl == null ? const Text('🐾', style: TextStyle(fontSize: 36)) : null,
                      ),
                      const SizedBox(height: 16),
                      Text(report.petName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text('${report.speciesName}${report.breedName == null ? '' : ' · ${report.breedName}'}', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _InfoCard(icon: Icons.campaign, title: report.title, subtitle: report.description),
              _InfoCard(icon: Icons.location_on, title: 'Último lugar visto', subtitle: report.lastSeenAddress ?? 'No indicado'),
              _InfoCard(icon: Icons.color_lens, title: 'Color', subtitle: report.color ?? 'No indicado'),
              _InfoCard(icon: Icons.phone, title: 'Contacto', subtitle: report.contactPhone ?? 'No indicado'),
              _InfoCard(icon: Icons.card_giftcard, title: 'Recompensa', subtitle: report.rewardAmount == null ? 'No indicada' : '₡${report.rewardAmount}'),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Avistamientos se agregarán en el próximo sprint.')),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: const Text('Creo que la vi'),
              ),
            ],
          ),
          error: (error, _) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
