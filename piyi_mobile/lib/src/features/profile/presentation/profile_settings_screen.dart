import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/navigation/piyi_navigation_helper.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  const ProfileSettingsScreen({super.key});

  static const route = '/profile/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PiyiPageScaffold(
      title: 'Configuracion',
      onBack: () => PiyiNavigationHelper.backOrHome(context),
      child: ListView(
        children: const [
          PiyiBannerCard(
            icon: Icons.person,
            title: 'Perfil',
            subtitle: 'Preferencias basicas de tu cuenta.',
            color: PiyiColors.primary,
          ),
          SizedBox(height: PiyiSpacing.xl),
          PiyiSection(
            title: 'MVP',
            child: Column(
              children: [
                PiyiTile(
                  icon: Icons.location_off,
                  title: 'Alertas por zona pausadas',
                  subtitle:
                      'Primero dejaremos fuerte el flujo simple de mascotas perdidas.',
                  color: PiyiColors.info,
                ),
                SizedBox(height: PiyiSpacing.sm),
                PiyiTile(
                  icon: Icons.notifications_none,
                  title: 'Push notifications pausadas',
                  subtitle:
                      'Las notificaciones avanzadas volveran cuando el MVP este validado.',
                  color: PiyiColors.warning,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
