import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
import '../../../core/navigation/piyi_navigation_helper.dart';
import '../data/business_catalog_item.dart';
import '../data/business_catalog_item_type.dart';
import 'catalog_controller.dart';
import 'catalog_item_detail_screen.dart';

class CatalogSearchScreen extends ConsumerStatefulWidget {
  const CatalogSearchScreen({super.key});

  static const route = '/catalog';

  @override
  ConsumerState<CatalogSearchScreen> createState() => _CatalogSearchScreenState();
}

class _CatalogSearchScreenState extends ConsumerState<CatalogSearchScreen> {
  final _searchController = TextEditingController();
  final _categoryController = TextEditingController();
  final _brandController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _categoryController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  void _applySearch() {
    ref.read(catalogSearchStateProvider.notifier).state = ref
        .read(catalogSearchStateProvider)
        .copyWith(
          search: _searchController.text.trim(),
          category: _categoryController.text.trim(),
          brand: _brandController.text.trim(),
        );

    ref.invalidate(catalogSearchResultsProvider);
  }

  void _clearSearch() {
    _searchController.clear();
    _categoryController.clear();
    _brandController.clear();

    ref.read(catalogSearchStateProvider.notifier).state = const CatalogSearchState();
    ref.invalidate(catalogSearchResultsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(catalogSearchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => PiyiNavigationHelper.backOrHome(context),
        ),
        title: const Text('CatÃƒ¡logo'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(catalogSearchResultsProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(PiyiSpacing.md),
        child: Column(
          children: [
            PiyiBannerCard(
              icon: Icons.search,
              title: 'Busca productos y servicios',
              subtitle: 'Encuentra proveedores Pro y contÃƒ¡ctalos directamente.',
              color: PiyiColors.primary,
            ),
            const SizedBox(height: PiyiSpacing.md),
            PiyiCard(
              child: Column(
                children: [
                  PiyiTextField(
                    controller: _searchController,
                    label: 'Ã‚¿QuÃƒÂ© necesitas?',
                    hint: 'Shampoo medicado, corte schnauzer, alimento senior...',
                    icon: Icons.search,
                  ),
                  const SizedBox(height: PiyiSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: PiyiTextField(
                          controller: _categoryController,
                          label: 'CategorÃƒÂ­a',
                          hint: 'Medicamento, grooming...',
                          icon: Icons.category,
                        ),
                      ),
                      const SizedBox(width: PiyiSpacing.sm),
                      Expanded(
                        child: PiyiTextField(
                          controller: _brandController,
                          label: 'Marca',
                          hint: 'Marca opcional',
                          icon: Icons.local_offer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: PiyiSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: PiyiPrimaryButton(
                          label: 'Buscar',
                          icon: Icons.search,
                          onPressed: _applySearch,
                        ),
                      ),
                      const SizedBox(width: PiyiSpacing.sm),
                      IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: PiyiSpacing.md),
            Expanded(
              child: resultsAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return PiyiEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No encontramos resultados',
                      message: 'Prueba con otro producto, servicio, marca o categorÃƒÂ­a.',
                      actionLabel: 'Limpiar bÃƒÂºsqueda',
                      onAction: _clearSearch,
                    );
                  }

                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: PiyiSpacing.sm),
                    itemBuilder: (context, index) => _CatalogItemCard(item: items[index]),
                  );
                },
                error: (error, _) => PiyiEmptyState(
                  icon: Icons.error_outline,
                  title: 'No pudimos buscar',
                  message: ApiErrorMessage.fromObject(error),
                  actionLabel: 'Reintentar',
                  onAction: () => ref.invalidate(catalogSearchResultsProvider),
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

class _CatalogItemCard extends StatelessWidget {
  const _CatalogItemCard({required this.item});

  final BusinessCatalogItem item;

  @override
  Widget build(BuildContext context) {
    return PiyiCard(
      onTap: () => context.go(CatalogItemDetailScreen.path(item.id)),
      child: Row(
        children: [
          _ImageBox(photoUrl: item.photoUrl),
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
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                      ),
                    ),
                    if (item.isFeatured)
                      const PiyiBadge(label: 'Destacado', color: PiyiColors.warning),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${catalogTypeLabel(item.type)}${item.brand == null ? '' : ' Ã‚Â· ${item.brand}'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.businessName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    PiyiBadge(
                      label: item.priceLabel,
                      color: PiyiColors.primary,
                    ),
                    const SizedBox(width: 6),
                    PiyiBadge(
                      label: item.availabilityLabel,
                      color: item.isAvailable ? PiyiColors.success : PiyiColors.warning,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  const _ImageBox({this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    if (photoUrl == null || photoUrl!.isEmpty) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: PiyiColors.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(PiyiRadius.lg),
        ),
        child: const Icon(Icons.inventory_2, color: PiyiColors.primary),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(PiyiRadius.lg),
      child: Image.network(
        photoUrl!,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 72,
          height: 72,
          color: PiyiColors.primary.withOpacity(0.12),
          child: const Icon(Icons.image_not_supported),
        ),
      ),
    );
  }
}
