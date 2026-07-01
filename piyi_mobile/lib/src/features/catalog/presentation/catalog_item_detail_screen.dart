import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
import '../../../core/navigation/piyi_navigation_helper.dart';
import '../../../core/utils/external_launcher.dart';
import '../data/business_catalog_item.dart';
import '../data/business_catalog_item_type.dart';
import 'catalog_controller.dart';

class CatalogItemDetailScreen extends ConsumerWidget {
  const CatalogItemDetailScreen({
    super.key,
    required this.itemId,
  });

  static const route = '/catalog/:id';
  static String path(String id) => '/catalog/$id';

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(catalogItemDetailProvider(itemId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => PiyiNavigationHelper.backOrHome(context),
        ),
        title: const Text('Detalle'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(PiyiSpacing.md),
        child: itemAsync.when(
          data: (item) => ListView(
            children: [
              _Header(item: item),
              const SizedBox(height: PiyiSpacing.md),
              PiyiSection(
                title: 'Información',
                child: Column(
                  children: [
                    PiyiTile(
                      icon: Icons.category,
                      title: 'Tipo',
                      subtitle: catalogTypeLabel(item.type),
                      color: PiyiColors.primary,
                    ),
                    const SizedBox(height: PiyiSpacing.sm),
                    PiyiTile(
                      icon: Icons.description,
                      title: 'Descripción',
                      subtitle: item.description ?? 'Sin descripción',
                      color: PiyiColors.secondary,
                    ),
                    const SizedBox(height: PiyiSpacing.sm),
                    PiyiTile(
                      icon: Icons.local_offer,
                      title: 'Marca / Categoría',
                      subtitle: '${item.brand ?? 'Marca no indicada'} · ${item.category ?? 'Categoría no indicada'}',
                      color: PiyiColors.info,
                    ),
                    const SizedBox(height: PiyiSpacing.sm),
                    PiyiTile(
                      icon: Icons.qr_code,
                      title: 'Código / SKU',
                      subtitle: 'Código: ${item.barcode ?? 'No indicado'}\nSKU: ${item.sku ?? 'No indicado'}',
                      color: PiyiColors.warning,
                    ),
                    const SizedBox(height: PiyiSpacing.sm),
                    PiyiTile(
                      icon: Icons.pets,
                      title: 'Mascota objetivo',
                      subtitle: 'Especie: ${item.petSpecies ?? 'No indicada'}\nRaza: ${item.breedTarget ?? 'No indicada'}\nEdad: ${item.ageTarget ?? 'No indicada'}',
                      color: PiyiColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: PiyiSpacing.xl),
              PiyiSection(
                title: 'Proveedor',
                child: Column(
                  children: [
                    PiyiTile(
                      icon: Icons.store,
                      title: item.businessName,
                      subtitle: item.businessAddress ?? 'Dirección no indicada',
                      color: PiyiColors.secondary,
                      trailing: item.businessIsVerified
                          ? const Icon(Icons.verified, color: PiyiColors.success)
                          : null,
                    ),
                    const SizedBox(height: PiyiSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: PiyiPrimaryButton(
                            label: 'WhatsApp',
                            icon: Icons.chat,
                            onPressed: () async {
                              try {
                                await ExternalLauncher.openWhatsApp(
                                  item.businessWhatsApp ?? item.businessPhone,
                                );
                              } catch (_) {
                                if (context.mounted) {
                                  PiyiSnackBar.error(context, 'No se pudo abrir WhatsApp.');
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: PiyiSpacing.sm),
                        Expanded(
                          child: PiyiSecondaryButton(
                            label: 'Llamar',
                            icon: Icons.phone,
                            onPressed: () async {
                              try {
                                await ExternalLauncher.callPhone(item.businessPhone);
                              } catch (_) {
                                if (context.mounted) {
                                  PiyiSnackBar.error(context, 'No se pudo abrir el marcador.');
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PiyiSpacing.sm),
                    PiyiSecondaryButton(
                      label: 'Cómo llegar',
                      icon: Icons.directions,
                      onPressed: () async {
                        try {
                          await ExternalLauncher.openMaps(
                            latitude: item.businessLatitude,
                            longitude: item.businessLongitude,
                            query: item.businessAddress ?? item.businessName,
                          );
                        } catch (_) {
                          if (context.mounted) {
                            PiyiSnackBar.error(context, 'No se pudo abrir Google Maps.');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: PiyiSpacing.xl),
              const PiyiAlertCard(
                title: 'Compra directa con el proveedor',
                subtitle: 'Piyí solo muestra información. La compra, pago o entrega se acuerda directamente con el negocio.',
                actionLabel: 'Entendido',
              ),
            ],
          ),
          error: (error, _) => PiyiEmptyState(
            icon: Icons.error_outline,
            title: 'No pudimos cargar el detalle',
            message: ApiErrorMessage.fromObject(error),
            actionLabel: 'Reintentar',
            onAction: () => ref.invalidate(catalogItemDetailProvider(itemId)),
          ),
          loading: () => const PiyiLoadingList(itemCount: 5),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.item});

  final BusinessCatalogItem item;

  @override
  Widget build(BuildContext context) {
    return PiyiCard(
      padding: const EdgeInsets.all(PiyiSpacing.lg),
      child: Column(
        children: [
          if (item.photoUrl != null && item.photoUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(PiyiRadius.xl),
              child: Image.network(
                item.photoUrl!,
                height: 210,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: PiyiColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(PiyiRadius.xl),
              ),
              child: const Center(
                child: Icon(Icons.inventory_2, size: 72, color: PiyiColors.primary),
              ),
            ),
          const SizedBox(height: PiyiSpacing.lg),
          Text(
            item.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: PiyiSpacing.sm),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              PiyiBadge(label: item.priceLabel, color: PiyiColors.primary),
              PiyiBadge(
                label: item.availabilityLabel,
                color: item.isAvailable ? PiyiColors.success : PiyiColors.warning,
              ),
              if (item.isFeatured)
                const PiyiBadge(label: 'Destacado', color: PiyiColors.warning),
            ],
          ),
        ],
      ),
    );
  }
}
