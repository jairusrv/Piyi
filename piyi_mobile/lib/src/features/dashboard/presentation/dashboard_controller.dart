import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error_message.dart';
import '../../businesses/data/businesses_repository.dart';
import '../../lost_pets/data/lost_pets_public_repository.dart';
import '../../notifications/data/notifications_repository.dart';
import '../../pets/data/pets_repository.dart';
import '../data/dashboard_models.dart';

class _SafeCountResult {
  const _SafeCountResult({required this.count, this.error});

  final int count;
  final String? error;
}

final dashboardSummaryProvider =
    FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final pets = await _safeCount(
    () => ref.watch(petsRepositoryProvider).getMyPets(),
  );
  final lostPets = await _safeCount(
    () => ref.watch(lostPetsPublicRepositoryProvider).getActive(),
  );
  final notifications = await _safeCount(
    () => ref.watch(notificationsRepositoryProvider).getMyNotifications(
          unreadOnly: true,
        ),
  );
  final businesses = await _safeCount(
    () => ref.watch(businessesRepositoryProvider).search(),
  );

  return DashboardSummary(
    petsCount: pets.count,
    lostPetsCount: lostPets.count,
    notificationsCount: notifications.count,
    businessesCount: businesses.count,
    petsError: pets.error,
    lostPetsError: lostPets.error,
    notificationsError: notifications.error,
    businessesError: businesses.error,
  );
});

Future<_SafeCountResult> _safeCount(
  Future<List<dynamic>> Function() loader,
) async {
  try {
    final items = await loader();
    return _SafeCountResult(count: items.length);
  } catch (error) {
    return _SafeCountResult(
      count: 0,
      error: ApiErrorMessage.fromObject(error),
    );
  }
}

final dashboardActivitiesProvider = Provider<List<DashboardActivity>>((ref) {
  return const [
    DashboardActivity(
      title: 'Piyi Beta esta activo',
      subtitle:
          'Ya puedes probar mascotas, negocios y reportes de mascotas perdidas.',
      type: 'success',
    ),
    DashboardActivity(
      title: 'Reportes simples',
      subtitle:
          'Publica una mascota perdida y recibe avistamientos de la comunidad.',
      type: 'location',
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
      subtitle: 'Agenda tus proximas citas desde el perfil de mascota.',
      dateLabel: 'Nuevo',
      type: 'appointment',
    ),
  ];
});
