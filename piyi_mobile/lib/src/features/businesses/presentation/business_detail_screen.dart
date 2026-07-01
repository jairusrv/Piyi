import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
import '../../../core/utils/external_launcher.dart';
import 'businesses_controller.dart';

class BusinessDetailScreen extends ConsumerWidget {
  const BusinessDetailScreen({super.key, required this.businessId});

  static const route = '/businesses/:id';
  static String path(String id) => '/businesses/$id';

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessAsync = ref.watch(businessDetailProvider(businessId));

    return Scaffold(
      appBar: AppBar(title: const Text('Negocio')),
      body: SafeArea(
        minimum: const EdgeInsets.all(PiyiSpacing.md),
        child: businessAsync.when(
          data: (business) => RefreshIndicator(
            onRefresh: () async => ref.invalidate(businessDetailProvider(businessId)),
            child: ListView(
              children: [
                PiyiBannerCard(
                  icon: Icons.store,
                  title: business.name,
                  subtitle: business.businessTypeName ?? 'Servicio para mascotas',
                  color: PiyiColors.secondary,
                ),
                const SizedBox(height: PiyiSpacing.md),
                PiyiCard(
                  child: Column(
                    children: [
                      PiyiAvatar(
                        imageUrl: business.logoUrl,
                        name: business.name,
                        size: 92,
                        icon: Icons.store,
                      ),
                      const SizedBox(height: PiyiSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              business.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                            ),
                          ),
                          if (business.isVerified) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.verified, color: PiyiColors.success),
                          ],
                        ],
                      ),
                      const SizedBox(height: PiyiSpacing.xs),
                      Text(
                        business.description ?? 'Sin descripción',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: PiyiSpacing.md),
                PiyiSection(
                  title: 'Contacto rápido',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: PiyiPrimaryButton(
                              label: 'Llamar',
                              icon: Icons.phone,
                              onPressed: () async {
                                try {
                                  await ExternalLauncher.callPhone(business.phone);
                                } catch (_) {
                                  if (context.mounted) {
                                    PiyiSnackBar.error(context, 'No se pudo abrir el marcador.');
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: PiyiSpacing.sm),
                          Expanded(
                            child: PiyiSecondaryButton(
                              label: 'WhatsApp',
                              icon: Icons.chat,
                              onPressed: () async {
                                try {
                                  await ExternalLauncher.openWhatsApp(business.whatsApp ?? business.phone);
                                } catch (_) {
                                  if (context.mounted) {
                                    PiyiSnackBar.error(context, 'No se pudo abrir WhatsApp.');
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
                              latitude: business.latitude,
                              longitude: business.longitude,
                              query: business.address ?? business.name,
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
                PiyiSection(
                  title: 'Información',
                  child: Column(
                    children: [
                      PiyiTile(
                        icon: Icons.location_on,
                        title: 'Dirección',
                        subtitle: business.address ?? 'No indicada',
                        color: PiyiColors.secondary,
                      ),
                      const SizedBox(height: PiyiSpacing.sm),
                      PiyiTile(
                        icon: Icons.location_city,
                        title: 'Zona',
                        subtitle: _zoneText(business.city, business.region, business.country),
                        color: PiyiColors.info,
                      ),
                      const SizedBox(height: PiyiSpacing.sm),
                      PiyiTile(
                        icon: Icons.phone,
                        title: 'Teléfono',
                        subtitle: business.phone ?? 'No indicado',
                        color: PiyiColors.primary,
                      ),
                      const SizedBox(height: PiyiSpacing.sm),
                      PiyiTile(
                        icon: Icons.email,
                        title: 'Email',
                        subtitle: business.email ?? 'No indicado',
                        color: PiyiColors.warning,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: PiyiSpacing.xl),
                PiyiSection(
                  title: 'Servicios',
                  child: business.services.isEmpty
                      ? const PiyiEmptyState(
                          icon: Icons.pets,
                          title: 'Sin servicios registrados',
                          message: 'Este negocio aún no ha agregado servicios.',
                        )
                      : Column(
                          children: business.services.map((service) {
                            final price = service.priceFrom == null
                                ? 'Precio no indicado'
                                : 'Desde ₡${service.priceFrom}${service.priceTo == null ? '' : ' hasta ₡${service.priceTo}'}';

                            return Padding(
                              padding: const EdgeInsets.only(bottom: PiyiSpacing.sm),
                              child: PiyiTile(
                                icon: Icons.pets,
                                title: service.name,
                                subtitle: '${service.description ?? 'Sin descripción'}\n$price',
                                color: PiyiColors.primary,
                              ),
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: PiyiSpacing.xl),
                PiyiSection(
                  title: 'Horario',
                  child: business.schedules.isEmpty
                      ? const PiyiEmptyState(
                          icon: Icons.schedule,
                          title: 'Horario no indicado',
                          message: 'Este negocio aún no ha registrado su horario.',
                        )
                      : Column(
                          children: business.schedules.map((schedule) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: PiyiSpacing.sm),
                              child: PiyiTile(
                                icon: Icons.schedule,
                                title: _dayName(schedule.dayOfWeek),
                                subtitle: schedule.isClosed
                                    ? 'Cerrado'
                                    : '${schedule.opensAt ?? ''} - ${schedule.closesAt ?? ''}',
                                color: schedule.isClosed ? PiyiColors.error : PiyiColors.success,
                              ),
                            );
                          }).toList(),
                        ),
                ),
                if (business.photos.isNotEmpty) ...[
                  const SizedBox(height: PiyiSpacing.xl),
                  PiyiSection(
                    title: 'Fotos',
                    child: SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: business.photos.length,
                        separatorBuilder: (_, __) => const SizedBox(width: PiyiSpacing.sm),
                        itemBuilder: (context, index) {
                          final photo = business.photos[index];

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(PiyiRadius.xl),
                            child: Image.network(
                              photo.photoUrl,
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: PiyiSpacing.xl),
              ],
            ),
          ),
          error: (error, _) => PiyiEmptyState(
            icon: Icons.error_outline,
            title: 'No pudimos cargar el negocio',
            message: ApiErrorMessage.fromObject(error),
            actionLabel: 'Reintentar',
            onAction: () => ref.invalidate(businessDetailProvider(businessId)),
          ),
          loading: () => const PiyiLoadingList(itemCount: 5),
        ),
      ),
    );
  }

  static String _zoneText(String? city, String? region, String? country) {
    final text = '${city ?? ''} ${region ?? ''} ${country ?? ''}'.trim();
    return text.isEmpty ? 'No indicada' : text;
  }

  static String _dayName(int day) {
    switch (day) {
      case 0:
        return 'Domingo';
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      default:
        return 'Día';
    }
  }
}
