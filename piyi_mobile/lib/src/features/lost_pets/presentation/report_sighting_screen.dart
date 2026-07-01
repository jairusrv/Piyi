import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
import 'lost_pet_detail_screen.dart';
import 'lost_pet_sightings_controller.dart';
import '../data/lost_pet_sightings_repository.dart';

class ReportSightingScreen extends ConsumerStatefulWidget {
  const ReportSightingScreen({super.key, required this.lostPetId});

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
      PiyiSnackBar.warning(context, 'Latitud y longitud son requeridas.');
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

      PiyiSnackBar.success(context, 'Avistamiento reportado correctamente.');
      context.go(LostPetDetailScreen.path(widget.lostPetId));
    } on DioException catch (e) {
      if (!mounted) return;
      PiyiSnackBar.error(context, ApiErrorMessage.fromDio(e));
    } catch (e) {
      if (!mounted) return;
      PiyiSnackBar.error(context, ApiErrorMessage.fromObject(e));
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
        minimum: const EdgeInsets.all(PiyiSpacing.md),
        child: ListView(
          children: [
            PiyiBannerCard(
              icon: Icons.visibility,
              title: '¿Crees que la viste?',
              subtitle: 'Comparte la ubicación y detalles para ayudar al dueño.',
              color: PiyiColors.error,
            ),
            const SizedBox(height: PiyiSpacing.xl),
            PiyiSection(
              title: 'Ubicación',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PiyiTextField(
                          controller: _latitudeController,
                          label: 'Latitud',
                          icon: Icons.my_location,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: PiyiSpacing.sm),
                      Expanded(
                        child: PiyiTextField(
                          controller: _longitudeController,
                          label: 'Longitud',
                          icon: Icons.explore,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: PiyiSpacing.sm),
                  PiyiTextField(
                    controller: _addressController,
                    label: 'Lugar',
                    hint: 'Ej: Frente al supermercado, parque...',
                    icon: Icons.place,
                  ),
                ],
              ),
            ),
            const SizedBox(height: PiyiSpacing.xl),
            PiyiSection(
              title: 'Detalles',
              child: Column(
                children: [
                  PiyiTextField(
                    controller: _observationController,
                    label: 'Observación',
                    hint: 'Qué viste, hacia dónde iba, collar...',
                    icon: Icons.notes,
                    maxLines: 4,
                  ),
                  const SizedBox(height: PiyiSpacing.sm),
                  PiyiTextField(
                    controller: _photoUrlController,
                    label: 'URL de foto opcional',
                    icon: Icons.image,
                  ),
                ],
              ),
            ),
            const SizedBox(height: PiyiSpacing.xl),
            PiyiPrimaryButton(
              label: 'Enviar avistamiento',
              icon: Icons.send,
              isLoading: _isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
