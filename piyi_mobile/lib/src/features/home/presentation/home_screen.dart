import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/login_screen.dart';
import '../../businesses/presentation/businesses_screen.dart';
import '../../lost_pets/presentation/lost_pets_screen.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../../pets/presentation/pets_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const route = '/home';

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authRepositoryProvider).logout();
    if (context.mounted) context.go(LoginScreen.route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piyí'),
        actions: [
          IconButton(
            onPressed: () => context.go(NotificationsScreen.route),
            icon: const Icon(Icons.notifications),
          ),
          IconButton(onPressed: () => _logout(context, ref), icon: const Icon(Icons.logout)),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Text('Hola 👋', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('El hogar digital de tus mascotas.', style: TextStyle(fontSize: 17)),
            const SizedBox(height: 24),
            _HomeCard(icon: '🐶', title: 'Mis mascotas', subtitle: 'Registra y administra tus mascotas.', onTap: () => context.go(PetsScreen.route)),
            _HomeCard(icon: '📍', title: 'Mascotas perdidas', subtitle: 'Reportes y alertas por zona.', onTap: () => context.go(LostPetsScreen.route)),
            _HomeCard(icon: '🏥', title: 'Servicios cercanos', subtitle: 'Veterinarias, groomers, tiendas y más.', onTap: () => context.go(BusinessesScreen.route)),
            _HomeCard(icon: '🔔', title: 'Notificaciones', subtitle: 'Alertas y avisos importantes.', onTap: () => context.go(NotificationsScreen.route)),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
