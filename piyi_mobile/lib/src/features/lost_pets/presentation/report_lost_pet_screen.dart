import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../pets/presentation/pet_detail_screen.dart';
import '../data/lost_pets_repository.dart';

class ReportLostPetScreen extends ConsumerStatefulWidget {
  const ReportLostPetScreen({
    super.key,
    required this.petId,
  });

  static const route = '/pets/:petId/report-lost';
  static String path(String petId) => '/pets/$petId/report-lost';

  final String petId;

  @override
  ConsumerState<ReportLostPetScreen> createState() => _ReportLostPetScreenState();
}

class _ReportLostPetScreenState extends ConsumerState<ReportLostPetScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _rewardController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _rewardController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título y descripción son requeridos.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(lostPetsRepositoryProvider).reportLostPet(
            petId: widget.petId,
            title: title,
            description: description,
            lastSeenAddress: _emptyToNull(_addressController.text),
            lastSeenLatitude: num.tryParse(_latitudeController.text.trim()),
            lastSeenLongitude: num.tryParse(_longitudeController.text.trim()),
            contactPhone: _emptyToNull(_phoneController.text),
            rewardAmount: num.tryParse(_rewardController.text.trim()),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte creado correctamente.')),
      );

      context.go(PetDetailScreen.path(widget.petId));
    } on DioException catch (e) {
      final data = e.response?.data;
      var message = 'No se pudo crear el reporte.';

      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (data != null) {
        message = data.toString();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
        title: const Text('Reportar perdida'),
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
                    const Icon(Icons.location_on, size: 56),
                    const SizedBox(height: 12),
                    const Text(
                      'Ayudemos a encontrarla',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Publicaremos un reporte para que otros usuarios puedan colaborar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej: Se perdió Max en Cartago',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Color, tamaño, señas particulares, collar, comportamiento...',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Último lugar donde fue vista',
                hintText: 'Ej: Tejar del Guarco, cerca del parque',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latitudeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Latitud',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _longitudeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Longitud',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono de contacto',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _rewardController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Recompensa opcional',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: const Icon(Icons.campaign),
              label: Text(_isLoading ? 'Publicando...' : 'Publicar reporte'),
            ),
          ],
        ),
      ),
    );
  }
}
