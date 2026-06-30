import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'lost_pet_detail_screen.dart';
import 'lost_pet_sightings_controller.dart';
import '../data/lost_pet_sightings_repository.dart';

class ReportSightingScreen extends ConsumerStatefulWidget {
  const ReportSightingScreen({
    super.key,
    required this.lostPetId,
  });

  static const route = '/lost-pets/:lostPetId/report-sighting';
  static String path(String lostPetId) => '/lost-pets/$lostPetId/report-sighting';

  final String lostPetId;

  @override
  ConsumerState<ReportSightingScreen> createState() => _ReportSightingScreenState();
}

class _ReportSightingScreenState extends ConsumerState<ReportSightingScreen> {
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _addressController = TextEditingController();
  final _observationController = TextEditingController();
  final _photoUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _addressController.dispose();
    _observationController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final latitude = num.tryParse(_latitudeController.text.trim());
    final longitude = num.tryParse(_longitudeController.text.trim());

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Latitud y longitud son requeridas.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(lostPetSightingsRepositoryProvider).createSighting(
            lostPetId: widget.lostPetId,
            latitude: latitude,
            longitude: longitude,
            address: _emptyToNull(_addressController.text),
            observation: _emptyToNull(_observationController.text),
            photoUrl: _emptyToNull(_photoUrlController.text),
          );

      ref.invalidate(lostPetSightingsProvider(widget.lostPetId));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avistamiento reportado correctamente.')),
      );

      context.go(LostPetDetailScreen.path(widget.lostPetId));
    } on DioException catch (e) {
      final data = e.response?.data;
      var message = 'No se pudo reportar el avistamiento.';

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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _emptyToNull(String value) {
    final clean = value.trim();
    return clean.isEmpty ? null : clean;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar avistamiento'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Icon(Icons.visibility, size: 56),
                    const SizedBox(height: 12),
                    const Text(
                      '¿Crees que la viste?',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Comparte la ubicación y detalles para ayudar al dueño.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Lugar',
                hintText: 'Ej: Frente al supermercado, parque, calle...',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _observationController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Observación',
                hintText: 'Qué viste, hacia dónde iba, comportamiento, collar...',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _photoUrlController,
              decoration: const InputDecoration(
                labelText: 'URL de foto opcional',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: const Icon(Icons.send),
              label: Text(_isLoading ? 'Enviando...' : 'Enviar avistamiento'),
            ),
          ],
        ),
      ),
    );
  }
}
