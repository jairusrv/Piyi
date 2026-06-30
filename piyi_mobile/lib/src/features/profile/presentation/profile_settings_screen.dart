import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_settings_repository.dart';
import '../data/user_alert_setting_model.dart';
import 'profile_settings_controller.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  const ProfileSettingsScreen({super.key});

  static const route = '/profile/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(userAlertSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: settingsAsync.when(
          data: (settings) => _AlertSettingsForm(initial: settings),
          error: (error, _) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _AlertSettingsForm extends ConsumerStatefulWidget {
  const _AlertSettingsForm({required this.initial});

  final UserAlertSetting initial;

  @override
  ConsumerState<_AlertSettingsForm> createState() => _AlertSettingsFormState();
}

class _AlertSettingsFormState extends ConsumerState<_AlertSettingsForm> {
  late bool _enabled;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _radiusController;
  late final TextEditingController _countryController;
  late final TextEditingController _regionController;
  late final TextEditingController _cityController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _enabled = widget.initial.lostPetAlertsEnabled;
    _latitudeController = TextEditingController(text: widget.initial.latitude?.toString() ?? '');
    _longitudeController = TextEditingController(text: widget.initial.longitude?.toString() ?? '');
    _radiusController = TextEditingController(text: widget.initial.radiusKm.toString());
    _countryController = TextEditingController(text: widget.initial.country ?? 'Costa Rica');
    _regionController = TextEditingController(text: widget.initial.region ?? '');
    _cityController = TextEditingController(text: widget.initial.city ?? '');
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _radiusController.dispose();
    _countryController.dispose();
    _regionController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final radius = num.tryParse(_radiusController.text.trim()) ?? 10;

    if (radius <= 0 || radius > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El radio debe estar entre 1 y 100 km.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(profileSettingsRepositoryProvider).updateAlertSettings(
            lostPetAlertsEnabled: _enabled,
            latitude: num.tryParse(_latitudeController.text.trim()),
            longitude: num.tryParse(_longitudeController.text.trim()),
            radiusKm: radius,
            country: _emptyToNull(_countryController.text),
            region: _emptyToNull(_regionController.text),
            city: _emptyToNull(_cityController.text),
          );

      ref.invalidate(userAlertSettingsProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuración guardada.')),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      var message = 'No se pudo guardar.';

      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (data != null) {
        message = data.toString();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String? _emptyToNull(String value) {
    final clean = value.trim();
    return clean.isEmpty ? null : clean;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const Icon(Icons.notifications_active, size: 56),
                const SizedBox(height: 12),
                const Text(
                  'Alertas por zona',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'Define dónde quieres recibir alertas cuando una mascota se pierda cerca.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          value: _enabled,
          title: const Text('Recibir alertas de mascotas perdidas'),
          subtitle: const Text('Te notificaremos si hay reportes cerca de tu zona.'),
          onChanged: (value) => setState(() => _enabled = value),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _latitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Latitud'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _longitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Longitud'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _radiusController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Radio en km',
            hintText: 'Ej: 10',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _countryController,
          decoration: const InputDecoration(labelText: 'País'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _regionController,
          decoration: const InputDecoration(labelText: 'Provincia'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cityController,
          decoration: const InputDecoration(labelText: 'Ciudad'),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _isSaving ? null : _save,
          icon: const Icon(Icons.save),
          label: Text(_isSaving ? 'Guardando...' : 'Guardar configuración'),
        ),
      ],
    );
  }
}
