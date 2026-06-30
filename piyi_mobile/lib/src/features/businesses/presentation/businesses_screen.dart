import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'business_detail_screen.dart';
import 'businesses_controller.dart';

class BusinessesScreen extends ConsumerStatefulWidget {
  const BusinessesScreen({super.key});

  static const route = '/businesses';

  @override
  ConsumerState<BusinessesScreen> createState() => _BusinessesScreenState();
}

class _BusinessesScreenState extends ConsumerState<BusinessesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    ref.read(businessSearchTextProvider.notifier).state = _searchController.text.trim();
    ref.invalidate(businessesListProvider);
  }

  void _clear() {
    _searchController.clear();
    ref.read(businessSearchTextProvider.notifier).state = '';
    ref.invalidate(businessesListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final businessesAsync = ref.watch(businessesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Servicios cercanos')),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          labelText: 'Buscar',
                          hintText: 'Veterinaria, grooming, tienda...',
                        ),
                        onSubmitted: (_) => _search(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(onPressed: _search, icon: const Icon(Icons.search)),
                    IconButton(onPressed: _clear, icon: const Icon(Icons.clear)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: businessesAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('No hay negocios registrados todavía.', textAlign: TextAlign.center),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(businessesListProvider),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: item.logoUrl == null ? null : NetworkImage(item.logoUrl!),
                              child: item.logoUrl == null ? const Icon(Icons.store) : null,
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                                ),
                                if (item.isVerified) const Icon(Icons.verified, size: 18),
                              ],
                            ),
                            subtitle: Text(
                              '${item.businessTypeName ?? 'Servicio'}\n${item.address ?? item.city ?? 'Ubicación no indicada'}',
                            ),
                            isThreeLine: true,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.go(BusinessDetailScreen.path(item.id)),
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
