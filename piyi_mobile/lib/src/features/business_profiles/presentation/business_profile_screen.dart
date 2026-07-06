import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
import '../../../core/navigation/piyi_navigation_helper.dart';
import '../../../core/utils/external_launcher.dart';
import '../data/business_profile.dart';
import 'business_profile_controller.dart';

class BusinessProfileScreen extends ConsumerWidget {
  const BusinessProfileScreen({
    super.key,
    required this.businessId,
  });

  static const route = '/business-profiles/:businessId';
  static String path(String businessId) => '/business-profiles/$businessId';

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(businessProfileProvider(businessId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => PiyiNavigationHelper.backOrHome(context),
        ),
        title: const Text('Perfil del negocio'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(businessProfileProvider(businessId)),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(PiyiSpacing.md),
        child: profileAsync.when(
          data: (profile) => RefreshIndicator(
            onRefresh: () async => ref.invalidate(businessProfileProvider(businessId)),
            child: ListView(
              children: [
                _BusinessHero(profile: profile),
                const SizedBox(height: PiyiSpacing.md),
                _QuickActions(profile: profile),
                const SizedBox(height: PiyiSpacing.xl),
                _AboutSection(profile: profile),
                const SizedBox(height: PiyiSpacing.xl),
                _FeaturesSection(profile: profile),
                const SizedBox(height: PiyiSpacing.xl),
                _ContactSection(profile: profile),
                if (profile.gallery.isNotEmpty) ...[
                  const SizedBox(height: PiyiSpacing.xl),
                  _GallerySection(profile: profile),
                ],
                const SizedBox(height: PiyiSpacing.xl),
              ],
            ),
          ),
          error: (error, _) => PiyiEmptyState(
            icon: Icons.error_outline,
            title: 'No pudimos cargar el perfil',
            message: ApiErrorMessage.fromObject(error),
            actionLabel: 'Reintentar',
            onAction: () => ref.invalidate(businessProfileProvider(businessId)),
          ),
          loading: () => const PiyiLoadingList(itemCount: 5),
        ),
      ),
    );
  }
}

class _BusinessHero extends StatelessWidget {
  const _BusinessHero({required this.profile});

  final BusinessProfile profile;

  @override
  Widget build(BuildContext context) {
    return PiyiCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(PiyiRadius.xl)),
            child: profile.bannerUrl == null || profile.bannerUrl!.isEmpty
                ? Container(
                    height: 150,
                    color: PiyiColors.secondary.withOpacity(0.16),
                    child: const Center(
                      child: Icon(Icons.store, size: 64, color: PiyiColors.secondary),
                    ),
                  )
                : Image.network(
                    profile.bannerUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(PiyiSpacing.lg),
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(0, -46),
                  child: PiyiAvatar(
                    imageUrl: profile.logoUrl,
                    name: profile.businessName,
                    size: 92,
                    icon: Icons.store,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              profile.businessName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                            ),
                          ),
                          if (profile.isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified, color: PiyiColors.success),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        profile.businessTypeName ?? 'Servicio para mascotas',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: PiyiSpacing.sm),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (profile.isProviderPro)
                            const PiyiBadge(label: 'PRO', color: PiyiColors.warning),
                          if (profile.hasEmergency24h)
                            const PiyiBadge(label: '24h', color: PiyiColors.error),
                          if (profile.hasHomeService)
                            const PiyiBadge(label: 'A domicilio', color: PiyiColors.primary),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.profile});

  final BusinessProfile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PiyiPrimaryButton(
            label: 'WhatsApp',
            icon: Icons.chat,
            onPressed: () async {
              try {
                await ExternalLauncher.openWhatsApp(profile.whatsApp ?? profile.phone);
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
                await ExternalLauncher.callPhone(profile.phone);
              } catch (_) {
                if (context.mounted) {
                  PiyiSnackBar.error(context, 'No se pudo abrir el marcador.');
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.profile});

  final BusinessProfile profile;

  @override
  Widget build(BuildContext context) {
    return PiyiSection(
      title: 'Acerca del negocio',
      child: Column(
        children: [
          PiyiTile(
            icon: Icons.description,
            title: 'DescripciÃƒÂ³n',
            subtitle: profile.longDescription ?? profile.shortDescription ?? 'Sin descripciÃƒÂ³n',
            color: PiyiColors.secondary,
          ),
          const SizedBox(height: PiyiSpacing.sm),
          PiyiTile(
            icon: Icons.star,
            title: 'Especialidades',
            subtitle: profile.specialties ?? 'No indicadas',
            color: PiyiColors.warning,
          ),
          const SizedBox(height: PiyiSpacing.sm),
          PiyiTile(
            icon: Icons.language,
            title: 'Idiomas',
            subtitle: profile.languages ?? 'No indicados',
            color: PiyiColors.info,
          ),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection({required this.profile});

  final BusinessProfile profile;

  @override
  Widget build(BuildContext context) {
    final features = <_Feature>[
      _Feature('SINPE', profile.acceptsSinpe, Icons.payments),
      _Feature('Tarjeta', profile.acceptsCard, Icons.credit_card),
      _Feature('Parqueo', profile.hasParking, Icons.local_parking),
      _Feature('Accesible', profile.isAccessible, Icons.accessible),
      _Feature('Emergencias 24h', profile.hasEmergency24h, Icons.emergency),
      _Feature('A domicilio', profile.hasHomeService, Icons.home),
    ].where((x) => x.enabled).toList();

    return PiyiSection(
      title: 'CaracterÃƒÂ­sticas',
      child: features.isEmpty
          ? const PiyiEmptyState(
              icon: Icons.info_outline,
              title: 'Sin caracterÃƒÂ­sticas registradas',
              message: 'Este negocio aÃƒÂºn no ha completado esta informaciÃƒÂ³n.',
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: features
                  .map(
                    (x) => Chip(
                      avatar: Icon(x.icon, size: 18),
                      label: Text(x.label),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.profile});

  final BusinessProfile profile;

  @override
  Widget build(BuildContext context) {
    return PiyiSection(
      title: 'Contacto y ubicaciÃƒÂ³n',
      child: Column(
        children: [
          PiyiTile(
            icon: Icons.location_on,
            title: 'DirecciÃƒÂ³n',
            subtitle: profile.address ?? 'No indicada',
            color: PiyiColors.error,
          ),
          const SizedBox(height: PiyiSpacing.sm),
          PiyiTile(
            icon: Icons.location_city,
            title: 'Zona',
            subtitle: '${profile.city ?? ''} ${profile.region ?? ''} ${profile.country ?? ''}'.trim().isEmpty
                ? 'No indicada'
                : '${profile.city ?? ''} ${profile.region ?? ''} ${profile.country ?? ''}'.trim(),
            color: PiyiColors.info,
          ),
          const SizedBox(height: PiyiSpacing.sm),
          PiyiSecondaryButton(
            label: 'CÃƒÂ³mo llegar',
            icon: Icons.directions,
            onPressed: () async {
              try {
                await ExternalLauncher.openMaps(
                  latitude: profile.latitude,
                  longitude: profile.longitude,
                  query: profile.address ?? profile.businessName,
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
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.profile});

  final BusinessProfile profile;

  @override
  Widget build(BuildContext context) {
    return PiyiSection(
      title: 'GalerÃƒÂ­a',
      child: SizedBox(
        height: 145,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: profile.gallery.length,
          separatorBuilder: (_, __) => const SizedBox(width: PiyiSpacing.sm),
          itemBuilder: (context, index) {
            final photo = profile.gallery[index];

            return ClipRRect(
              borderRadius: BorderRadius.circular(PiyiRadius.xl),
              child: Image.network(
                photo,
                width: 145,
                height: 145,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Feature {
  const _Feature(this.label, this.enabled, this.icon);

  final String label;
  final bool enabled;
  final IconData icon;
}
