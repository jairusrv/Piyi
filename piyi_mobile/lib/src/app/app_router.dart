import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/config/app_config.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/businesses/presentation/business_detail_screen.dart';
import '../features/businesses/presentation/businesses_screen.dart';
import '../features/catalog/presentation/catalog_item_detail_screen.dart';
import '../features/catalog/presentation/catalog_search_screen.dart';
import '../features/devices/presentation/devices_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/lost_pets/presentation/lost_pet_detail_screen.dart';
import '../features/lost_pets/presentation/lost_pets_screen.dart';
import '../features/lost_pets/presentation/report_lost_pet_screen.dart';
import '../features/lost_pets/presentation/report_sighting_screen.dart';
import '../features/map/presentation/map_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/pets/presentation/create_pet_screen.dart';
import '../features/pets/presentation/pet_detail_screen.dart';
import '../features/pets/presentation/pets_screen.dart';
import '../features/profile/presentation/profile_settings_screen.dart';
import '../features/push_diagnostics/presentation/push_diagnostics_screen.dart';
import '../features/splash/presentation/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: SplashScreen.route,
    routes: [
      GoRoute(
        path: SplashScreen.route,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.route,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RegisterScreen.route,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: HomeScreen.route,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: PetsScreen.route,
        builder: (context, state) => const PetsScreen(),
      ),
      GoRoute(
        path: CreatePetScreen.route,
        builder: (context, state) => const CreatePetScreen(),
      ),
      GoRoute(
        path: PetDetailScreen.route,
        builder: (context, state) =>
            PetDetailScreen(petId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: ReportLostPetScreen.route,
        builder: (context, state) =>
            ReportLostPetScreen(petId: state.pathParameters['petId']!),
      ),
      GoRoute(
        path: LostPetsScreen.route,
        builder: (context, state) => const LostPetsScreen(),
      ),
      GoRoute(
        path: LostPetDetailScreen.route,
        builder: (context, state) =>
            LostPetDetailScreen(lostPetId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: ReportSightingScreen.route,
        builder: (context, state) => ReportSightingScreen(
          lostPetId: state.pathParameters['lostPetId']!,
        ),
      ),
      GoRoute(
        path: BusinessesScreen.route,
        builder: (context, state) => const BusinessesScreen(),
      ),
      GoRoute(
        path: BusinessDetailScreen.route,
        builder: (context, state) =>
            BusinessDetailScreen(businessId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: NotificationsScreen.route,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: ProfileSettingsScreen.route,
        builder: (context, state) => const ProfileSettingsScreen(),
      ),
      GoRoute(
        path: MapScreen.route,
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: CatalogSearchScreen.route,
        builder: (context, state) => const CatalogSearchScreen(),
      ),
      GoRoute(
        path: CatalogItemDetailScreen.route,
        builder: (context, state) => CatalogItemDetailScreen(
          itemId: state.pathParameters['id']!,
        ),
      ),
      if (AppConfig.enableDevTools) ...[
        GoRoute(
          path: DevicesScreen.route,
          builder: (context, state) => const DevicesScreen(),
        ),
        GoRoute(
          path: PushDiagnosticsScreen.route,
          builder: (context, state) => const PushDiagnosticsScreen(),
        ),
      ],
    ],
  );
});
