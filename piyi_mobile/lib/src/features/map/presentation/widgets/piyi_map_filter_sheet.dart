import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../map_filter_controller.dart';

class PiyiMapFilterSheet extends ConsumerWidget {
  const PiyiMapFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(mapLayerFilterProvider);

    return SafeArea(
      minimum: const EdgeInsets.all(PiyiSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Filtros del mapa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: PiyiSpacing.md),
          _FilterTile(
            title: 'Todo',
            subtitle: 'Mascotas perdidas y negocios',
            icon: Icons.map,
            selected: selected == MapLayerFilter.all,
            onTap: () {
              ref.read(mapLayerFilterProvider.notifier).state = MapLayerFilter.all;
              Navigator.pop(context);
            },
          ),
          _FilterTile(
            title: 'Mascotas perdidas',
            subtitle: 'Solo reportes activos',
            icon: Icons.location_on,
            selected: selected == MapLayerFilter.lostPets,
            onTap: () {
              ref.read(mapLayerFilterProvider.notifier).state = MapLayerFilter.lostPets;
              Navigator.pop(context);
            },
          ),
          _FilterTile(
            title: 'Negocios',
            subtitle: 'Veterinarias, grooming, tiendas',
            icon: Icons.store,
            selected: selected == MapLayerFilter.businesses,
            onTap: () {
              ref.read(mapLayerFilterProvider.notifier).state = MapLayerFilter.businesses;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  const _FilterTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PiyiSpacing.sm),
      child: PiyiTile(
        icon: icon,
        title: title,
        subtitle: subtitle,
        color: selected ? PiyiColors.primary : PiyiColors.subtitle,
        trailing: selected ? const Icon(Icons.check_circle, color: PiyiColors.primary) : null,
        onTap: onTap,
      ),
    );
  }
}
