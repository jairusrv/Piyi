import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/pet_health_models.dart';
import '../data/pet_health_repository.dart';

final petQrProvider = FutureProvider.autoDispose.family<PetQrCode?, String>((ref, petId) {
  return ref.watch(petHealthRepositoryProvider).getQr(petId);
});

final petVaccinesProvider = FutureProvider.autoDispose.family<List<PetVaccine>, String>((ref, petId) {
  return ref.watch(petHealthRepositoryProvider).getVaccines(petId);
});

final petRemindersProvider = FutureProvider.autoDispose.family<List<PetReminder>, String>((ref, petId) {
  return ref.watch(petHealthRepositoryProvider).getReminders(petId);
});

final petAppointmentsProvider = FutureProvider.autoDispose.family<List<PetAppointment>, String>((ref, petId) {
  return ref.watch(petHealthRepositoryProvider).getAppointments(petId);
});
