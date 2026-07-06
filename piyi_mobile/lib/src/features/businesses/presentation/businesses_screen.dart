import 'package:flutter/material.dart';
import '../../core/navigation/piyi_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
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
      appBar: AppBar(
        leading: PiyiBackButton.fallbackHome(context),
        title: const Text('Servicios cercanos'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(businessesListProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(PiyiSpacing.md),
        child: Column(
          children: [
            PiyiBannerCard(
              icon: Icons.store,
              title: 'Servicios para mascotas',
              subtitle: 'Encuentra veterinarias, grooming, hoteles, tiendas y mÃ¡s.',
              color: PiyiColors.secondary,
            ),
            const SizedBox(height: PiyiSpacing.md),
            PiyiCard(
              child: Row(
                children: [
                  Expanded(
                    child: PiyiTextField(
                      controller: _searchController,
                      label: 'Buscar',
                      hint: 'Veterinaria, grooming, tienda...',
                      icon: Icons.search,
                    ),
                  ),
                  const SizedBox(width: PiyiSpacing.xs),
                  IconButton(onPressed: _search, icon: const Icon(Icons.search)),
                  IconButton(onPressed: _clear, icon: const Icon(Icons.clear)),
                ],
              ),
            ),
            const SizedBox(height: PiyiSpacing.md),
            Expanded(
              child: businessesAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return PiyiEmptyState(
                      icon: Icons.store_mall_directory,
                      title: 'No hay negocios registrados',
                      message: 'Cuando registremos veterinarias, groomers y tiendas aparecerÃ¡n aquÃ­.',
                      actionLabel: 'Actualizar',
                      onAction: () => ref.invalidate(businessesListProvider),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(businessesListProvider),
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: PiyiSpacing.sm),
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return PiyiCard(
                          onTap: () => context.go(BusinessDetailScreen.path(item.id)),
                          child: Row(
                            children: [
                              PiyiAvatar(
                                imageUrl: item.logoUrl,
                                name: item.name,
                                size: 64,
                                icon: Icons.store,
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
                                            item.name,
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                        if (item.isVerified)
                                          const PiyiBadge(label: 'Verificado', color: PiyiColors.success),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.businessTypeName ?? 'Servicio para mascotas',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.address ?? item.city ?? 'UbicaciÃ³n no indicada',
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
                  title: 'No pudimos cargar negocios',
                  message: ApiErrorMessage.fromObject(error),
                  actionLabel: 'Reintentar',
                  onAction: () => ref.invalidate(businessesListProvider),
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
