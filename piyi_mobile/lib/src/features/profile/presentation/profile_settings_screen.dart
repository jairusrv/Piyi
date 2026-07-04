import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/navigation/piyi_navigation_helper.dart';
import '../../location/data/current_location_result.dart';
import '../../location/presentation/widgets/piyi_current_location_card.dart';
import '../../location/presentation/widgets/piyi_use_current_location_button.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  static const route = '/profile/settings';

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  CurrentLocationResult? _safeZoneLocation;
  double _radiusKm = 5;

  void _saveSafeZone() {
    if (_safeZoneLocation == null) {
      PiyiSnackBar.warning(context, 'Primero usa tu ubicación actual.');
      return;
    }

    PiyiSnackBar.success(context, 'Zona segura guardada: ${_radiusKm.round()} km.');
  }

  @override
  Widget build(BuildContext context) {
    return PiyiPageScaffold(
      title: 'Configuración',
      onBack: () => PiyiNavigationHelper.backOrHome(context),
      child: ListView(
        children: [
          PiyiBannerCard(
            icon: Icons.settings,
            title: 'Configuración de Piyí',
            subtitle: 'Administra alertas, ubicación y preferencias.',
            color: PiyiColors.primary,
          ),
          const SizedBox(height: PiyiSpacing.xl),
          PiyiSection(
            title: 'Alertas por zona',
            child: Column(
              children: [
                const PiyiAlertCard(
                  title: 'Activa tu zona segura',
                  subtitle: 'Usaremos la ubicación actual de tu celular. No necesitas escribir coordenadas.',
                  actionLabel: 'Ubicación GPS',
                ),
                const SizedBox(height: PiyiSpacing.md),
                PiyiUseCurrentLocationButton(
                  label: 'Usar mi ubicación actual',
                  onLocation: (location) => setState(() => _safeZoneLocation = location),
                ),
                if (_safeZoneLocation != null) ...[
                  const SizedBox(height: PiyiSpacing.md),
                  PiyiCurrentLocationCard(
                    location: _safeZoneLocation!,
                    title: 'Centro de tu zona segura',
                  ),
                  const SizedBox(height: PiyiSpacing.md),
                  PiyiCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Radio: ${_radiusKm.round()} km',
                            style: const TextStyle(fontWeight: FontWeight.w900)),
                        Slider(
                          value: _radiusKm,
                          min: 1,
                          max: 50,
                          divisions: 49,
                          label: '${_radiusKm.round()} km',
                          onChanged: (value) => setState(() => _radiusKm = value),
                        ),
                        PiyiPrimaryButton(
                          label: 'Guardar zona segura',
                          icon: Icons.save,
                          onPressed: _saveSafeZone,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
