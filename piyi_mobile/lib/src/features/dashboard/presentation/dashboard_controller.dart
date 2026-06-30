import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../businesses/data/businesses_repository.dart';
import '../../lost_pets/data/lost_pets_public_repository.dart';
import '../../notifications/data/notifications_repository.dart';
import '../../pets/data/pets_repository.dart';
import '../data/dashboard_models.dart';

final dashboardSummaryProvider = FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final petsFuture = ref.watch(petsRepositoryProvider).getMyPets();
  final lostPetsFuture = ref.watch(lostPetsPublicRepositoryProvider).getActive();
  final notificationsFuture = ref.watch(notificationsRepositoryProvider).getMyNotifications(unreadOnly: true);
  final businessesFuture = ref.watch(businessesRepositoryProvider).search();

  final results = await Future.wait([
    petsFuture,
    lostPetsFuture,
    notificationsFuture,
    businessesFuture,
  ]);

  return DashboardSummary(
    petsCount: (results[0] as List).length,
    lostPetsCount: (results[1] as List).length,
    notificationsCount: (results[2] as List).length,
    businessesCount: (results[3] as List).length,
  );
});

final dashboardActivitiesProvider = Provider<List<DashboardActivity>>((ref) {
  return const [
    DashboardActivity(
      title: 'Piyí Beta está activo',
      subtitle: 'Ya puedes probar mascotas, negocios, alertas y notificaciones.',
      type: 'success',
    ),
    DashboardActivity(
      title: 'Configura tu zona',
      subtitle: 'Activa alertas para mascotas perdidas cerca de ti.',
      type: 'location',
    ),
    DashboardActivity(
      title: 'Registra tu dispositivo',
      subtitle: 'Prepara tu teléfono para recibir push notifications.',
      type: 'phone',
    ),
  ];
});

final dashboardRemindersProvider = Provider<List<DashboardReminder>>((ref) {
  return const [
    DashboardReminder(
      title: 'Vacuna pendiente',
      subtitle: 'Agrega vacunas para comenzar a ver recordatorios reales.',
      dateLabel: 'Pronto',
      type: 'vaccine',
    ),
    DashboardReminder(
      title: 'Cita veterinaria',
      subtitle: 'Agenda tus próximas citas desde el perfil de mascota.',
      dateLabel: 'Nuevo',
      type: 'appointment',
    ),
  ];
});
