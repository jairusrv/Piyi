import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/lost_pets/presentation/lost_pet_detail_screen.dart';
import '../features/lost_pets/presentation/lost_pets_screen.dart';
import '../features/lost_pets/presentation/report_lost_pet_screen.dart';
import '../features/lost_pets/presentation/report_sighting_screen.dart';
import '../features/pets/presentation/create_pet_screen.dart';
import '../features/pets/presentation/pet_detail_screen.dart';
import '../features/pets/presentation/pets_screen.dart';
import '../features/splash/presentation/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: SplashScreen.route,
    routes: [
      GoRoute(path: SplashScreen.route, builder: (context, state) => const SplashScreen()),
      GoRoute(path: LoginScreen.route, builder: (context, state) => const LoginScreen()),
      GoRoute(path: RegisterScreen.route, builder: (context, state) => const RegisterScreen()),
      GoRoute(path: HomeScreen.route, builder: (context, state) => const HomeScreen()),
      GoRoute(path: PetsScreen.route, builder: (context, state) => const PetsScreen()),
      GoRoute(path: CreatePetScreen.route, builder: (context, state) => const CreatePetScreen()),
      GoRoute(
        path: PetDetailScreen.route,
        builder: (context, state) => PetDetailScreen(petId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: ReportLostPetScreen.route,
        builder: (context, state) => ReportLostPetScreen(petId: state.pathParameters['petId']!),
      ),
      GoRoute(path: LostPetsScreen.route, builder: (context, state) => const LostPetsScreen()),
      GoRoute(
        path: LostPetDetailScreen.route,
        builder: (context, state) => LostPetDetailScreen(lostPetId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: ReportSightingScreen.route,
        builder: (context, state) => ReportSightingScreen(lostPetId: state.pathParameters['lostPetId']!),
      ),
    ],
  );
});
