import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/login_screen.dart';
import '../../businesses/presentation/businesses_screen.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import '../../lost_pets/presentation/lost_pets_screen.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../../pets/presentation/pets_screen.dart';
import '../../profile/presentation/profile_settings_screen.dart';
import '../../catalog/presentation/catalog_search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const route = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  Future<void> _logout(BuildContext context) async {
    await ref.read(authRepositoryProvider).logout();
    if (context.mounted) context.go(LoginScreen.route);
  }

  void _onBottomTap(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        break;
      case 1:
        context.go(PetsScreen.route);
        break;
      case 2:
        context.go(BusinessesScreen.route);
        break;
      case 3:
        context.go(LostPetsScreen.route);
        break;
      case 4:
        context.go(ProfileSettingsScreen.route);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final activities = ref.watch(dashboardActivitiesProvider);
    final reminders = ref.watch(dashboardRemindersProvider);

    return Scaffold(
      appBar: PiyiAppBar(
        title: 'Hola Jairo 👋',
        subtitle: 'Bienvenido nuevamente',
        actions: [
          IconButton(
            onPressed: () => context.go(NotificationsScreen.route),
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () => context.go(ProfileSettingsScreen.route),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: PiyiBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onBottomTap,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardSummaryProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(PiyiSpacing.md),
            children: [
              PiyiBannerCard(
                icon: Icons.pets,
                title: 'Cuida, protege y encuentra',
                subtitle:
                    'Todo lo importante de tus mascotas en un solo lugar.',
                color: PiyiColors.primary,
                onTap: () => context.go(PetsScreen.route),
              ),
              const SizedBox(height: PiyiSpacing.xl),
              PiyiSection(
                title: 'Tu resumen',
                child: summaryAsync.when(
                  data: (summary) => Column(
                    children: [
                      if (summary.hasPartialErrors) ...[
                        PiyiAlertCard(
                          title: 'Algunos datos no cargaron',
                          subtitle:
                              'La app sigue funcionando. Revisa migraciones o endpoints pendientes.',
                          actionLabel: 'Actualizar',
                          onTap: () => ref.invalidate(dashboardSummaryProvider),
                        ),
                        const SizedBox(height: PiyiSpacing.md),
                      ],
                      PiyiQuickActionGrid(
                        items: [
                          PiyiQuickActionItem(
                            icon: Icons.pets,
                            title: 'Mascotas',
                            subtitle:
                                summary.petsError ?? 'Tus perfiles registrados',
                            color: summary.petsError == null
                                ? PiyiColors.primary
                                : PiyiColors.error,
                            badge: '${summary.petsCount}',
                            onTap: () => context.go(PetsScreen.route),
                          ),
                          PiyiQuickActionItem(
                            icon: Icons.location_on,
                            title: 'Perdidas',
                            subtitle:
                                summary.lostPetsError ?? 'Reportes activos',
                            color: PiyiColors.error,
                            badge: '${summary.lostPetsCount}',
                            onTap: () => context.go(LostPetsScreen.route),
                          ),
                          PiyiQuickActionItem(
                            icon: Icons.notifications,
                            title: 'Alertas',
                            subtitle: summary.notificationsError ?? 'Sin leer',
                            color: summary.notificationsError == null
                                ? PiyiColors.warning
                                : PiyiColors.error,
                            badge: '${summary.notificationsCount}',
                            onTap: () => context.go(NotificationsScreen.route),
                          ),
                          PiyiQuickActionItem(
                            icon: Icons.store,
                            title: 'Negocios',
                            subtitle: summary.businessesError ??
                                'Servicios registrados',
                            color: summary.businessesError == null
                                ? PiyiColors.secondary
                                : PiyiColors.error,
                            badge: '${summary.businessesCount}',
                            onTap: () => context.go(BusinessesScreen.route),
                          ),
                        ],
                      ),
                    ],
                  ),
                  error: (error, _) => PiyiEmptyState(
                    icon: Icons.error_outline,
                    title: 'No pudimos cargar el resumen',
                    message: '$error',
                    actionLabel: 'Reintentar',
                    onAction: () => ref.invalidate(dashboardSummaryProvider),
                  ),
                  loading: () => const Column(
                    children: [
                      PiyiLoadingCard(),
                      SizedBox(height: PiyiSpacing.sm),
                      PiyiLoadingCard(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: PiyiSpacing.xl),
              PiyiSection(
                title: 'Accesos rápidos',
                child: Column(
                  children: [
                    PiyiTile(
                      icon: Icons.pets,
                      title: 'Mis mascotas',
                      subtitle: 'Perfiles, salud, QR y recordatorios.',
                      color: PiyiColors.primary,
                      onTap: () => context.go(PetsScreen.route),
                    ),
                    const SizedBox(height: PiyiSpacing.sm),
                    PiyiTile(
                      icon: Icons.location_on,
                      title: 'Mascotas perdidas',
                      subtitle: 'Reportes y avistamientos.',
                      color: PiyiColors.error,
                      onTap: () => context.go(LostPetsScreen.route),
                    ),
                    const SizedBox(height: PiyiSpacing.sm),
                    PiyiTile(
                      icon: Icons.store,
                      title: 'Servicios cercanos',
                      subtitle: 'Veterinarias, grooming, hoteles y tiendas.',
                      color: PiyiColors.secondary,
                      onTap: () => context.go(BusinessesScreen.route),
                    ),
                    const SizedBox(height: PiyiSpacing.sm),
                    PiyiTile(
                      icon: Icons.inventory_2,
                      title: 'Catálogo',
                      subtitle:
                          'Busca productos y servicios de proveedores Pro.',
                      color: PiyiColors.primary,
                      onTap: () => context.go(CatalogSearchScreen.route),
                    ),
                    PiyiTile(
                      icon: Icons.settings,
                      title: 'Perfil y configuración',
                      subtitle: 'Alertas por zona y dispositivos.',
                      color: PiyiColors.info,
                      onTap: () => context.go(ProfileSettingsScreen.route),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: PiyiSpacing.xl),
              PiyiSection(
                title: 'Próximos recordatorios',
                actionLabel: 'Ver mascotas',
                onActionTap: () => context.go(PetsScreen.route),
                child: Column(
                  children: reminders.map((reminder) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: PiyiSpacing.sm),
                      child: PiyiReminderCard(
                        title: reminder.title,
                        subtitle: reminder.subtitle,
                        dateLabel: reminder.dateLabel,
                        icon: _reminderIcon(reminder.type),
                        color: _reminderColor(reminder.type),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: PiyiSpacing.xl),
              PiyiSection(
                title: 'Actividad reciente',
                actionLabel: 'Notificaciones',
                onActionTap: () => context.go(NotificationsScreen.route),
                child: PiyiCard(
                  child: PiyiActivityTimeline(
                    items: activities.map((activity) {
                      return PiyiActivityItem(
                        icon: _activityIcon(activity.type),
                        title: activity.title,
                        subtitle: activity.subtitle,
                        color: _activityColor(activity.type),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: PiyiSpacing.xl),
              PiyiAlertCard(
                title: 'Activa tu zona segura',
                subtitle:
                    'Recibe alertas cuando una mascota se pierda cerca de ti.',
                actionLabel: 'Configurar',
                onTap: () => context.go(ProfileSettingsScreen.route),
              ),
              const SizedBox(height: PiyiSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  IconData _activityIcon(String type) {
    switch (type) {
      case 'location':
        return Icons.location_on;
      case 'phone':
        return Icons.phone_android;
      case 'success':
      default:
        return Icons.check_circle;
    }
  }

  Color _activityColor(String type) {
    switch (type) {
      case 'location':
        return PiyiColors.error;
      case 'phone':
        return PiyiColors.secondary;
      case 'success':
      default:
        return PiyiColors.success;
    }
  }

  IconData _reminderIcon(String type) {
    switch (type) {
      case 'vaccine':
        return Icons.vaccines;
      case 'appointment':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  Color _reminderColor(String type) {
    switch (type) {
      case 'vaccine':
        return PiyiColors.primary;
      case 'appointment':
        return PiyiColors.secondary;
      default:
        return PiyiColors.warning;
    }
  }
}
