import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'lost_pet_detail_screen.dart';
import 'lost_pets_controller.dart';

class LostPetsScreen extends ConsumerStatefulWidget {
  const LostPetsScreen({super.key});

  static const route = '/lost-pets';

  @override
  ConsumerState<LostPetsScreen> createState() => _LostPetsScreenState();
}

class _LostPetsScreenState extends ConsumerState<LostPetsScreen> {
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    ref.read(lostPetsFilterProvider.notifier).state = LostPetsFilter(
      city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
      region: _regionController.text.trim().isEmpty ? null : _regionController.text.trim(),
    );
    ref.invalidate(lostPetsListProvider);
  }

  void _clearFilter() {
    _cityController.clear();
    _regionController.clear();
    ref.read(lostPetsFilterProvider.notifier).state = const LostPetsFilter();
    ref.invalidate(lostPetsListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final lostPetsAsync = ref.watch(lostPetsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mascotas perdidas')),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'Ciudad'))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: _regionController, decoration: const InputDecoration(labelText: 'Provincia'))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: FilledButton.icon(onPressed: _applyFilter, icon: const Icon(Icons.search), label: const Text('Buscar'))),
                        const SizedBox(width: 10),
                        IconButton(onPressed: _clearFilter, icon: const Icon(Icons.clear)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: lostPetsAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(child: Text('No hay reportes activos en este momento.', textAlign: TextAlign.center));
                  }

                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(lostPetsListProvider),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: item.petPhotoUrl == null ? null : NetworkImage(item.petPhotoUrl!),
                              child: item.petPhotoUrl == null ? const Text('🐾') : null,
                            ),
                            title: Text(
                              item.petName.isEmpty ? item.title : item.petName,
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            subtitle: Text('${item.title}\n${item.lastSeenAddress ?? 'Ubicación no indicada'}'),
                            isThreeLine: true,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.go(LostPetDetailScreen.path(item.id)),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, _) => Center(child: Text('Error: $error')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
