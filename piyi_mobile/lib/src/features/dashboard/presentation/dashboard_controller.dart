import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../businesses/data/businesses_repository.dart';
import '../../lost_pets/data/lost_pets_public_repository.dart';
import '../../notifications/data/notifications_repository.dart';
import '../../pets/data/pets_repository.dart';
import '../data/dashboard_models.dart';
final dashboardSummaryProvider=FutureProvider.autoDispose<DashboardSummary>((ref) async{final pets=await ref.watch(petsRepositoryProvider).getMyPets();final lost=await ref.watch(lostPetsPublicRepositoryProvider).getActive();final notifications=await ref.watch(notificationsRepositoryProvider).getMyNotifications(unreadOnly:true);final businesses=await ref.watch(businessesRepositoryProvider).search();return DashboardSummary(petsCount:pets.length,lostPetsCount:lost.length,notificationsCount:notifications.length,businessesCount:businesses.length);});
final dashboardActivitiesProvider=Provider<List<DashboardActivity>>((ref)=>const[DashboardActivity(title:'Bienvenido a Piyí',subtitle:'Tu hogar digital para mascotas ya está tomando forma.',iconName:'pets'),DashboardActivity(title:'Configura tus alertas',subtitle:'Activa alertas por zona para mascotas perdidas.',iconName:'notifications'),DashboardActivity(title:'Registra tu dispositivo',subtitle:'Esto prepara las notificaciones push.',iconName:'phone')]);
