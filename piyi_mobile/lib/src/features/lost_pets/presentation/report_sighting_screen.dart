import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
import '../../../core/navigation/piyi_navigation_helper.dart';
import '../../location/data/current_location_result.dart';
import '../../location/presentation/widgets/piyi_current_location_card.dart';
import '../../location/presentation/widgets/piyi_use_current_location_button.dart';
import '../data/lost_pet_sightings_repository.dart';
import 'lost_pet_detail_screen.dart';
import 'lost_pet_sightings_controller.dart';

class ReportSightingScreen extends ConsumerStatefulWidget {
  const ReportSightingScreen({super.key, required this.lostPetId});

  static const route = '/lost-pets/:lostPetId/report-sighting';
  static String path(String lostPetId) => '/lost-pets/$lostPetId/report-sighting';

  final String lostPetId;

  @override
  ConsumerState<ReportSightingScreen> createState() => _ReportSightingScreenState();
}

class _ReportSightingScreenState extends ConsumerState<ReportSightingScreen> {
  final _addressController = TextEditingController();
  final _observationController = TextEditingController();
  final _photoUrlController = TextEditingController();

  CurrentLocationResult? _location;
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    _observationController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_location == null) {
      PiyiSnackBar.warning(context, 'Usa tu ubicación actual para reportar el avistamiento.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(lostPetSightingsRepositoryProvider).createSighting(
            lostPetId: widget.lostPetId,
            latitude: _location!.latitude,
            longitude: _location!.longitude,
            address: _emptyToNull(_addressController.text) ?? _location!.address ?? _location!.placeLabel,
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
    return PiyiPageScaffold(
      title: 'Reportar avistamiento',
      onBack: () => PiyiNavigationHelper.backOrHome(context),
      child: ListView(
        children: [
          const PiyiBannerCard(
            icon: Icons.visibility,
            title: '¿Crees que la viste?',
            subtitle: 'Usaremos tu ubicación actual para ayudar al dueño.',
            color: PiyiColors.error,
          ),
          const SizedBox(height: PiyiSpacing.xl),
          PiyiSection(
            title: 'Ubicación',
            child: Column(
              children: [
                PiyiUseCurrentLocationButton(
                  label: 'Usar ubicación actual',
                  onLocation: (location) {
                    setState(() => _location = location);
                    if (_addressController.text.trim().isEmpty) {
                      _addressController.text = location.address ?? location.placeLabel;
                    }
                  },
                ),
                if (_location != null) ...[
                  const SizedBox(height: PiyiSpacing.md),
                  PiyiCurrentLocationCard(location: _location!, title: 'Lugar del avistamiento'),
                ],
                const SizedBox(height: PiyiSpacing.sm),
                PiyiTextField(controller: _addressController, label: 'Referencia del lugar', hint: 'Ej: Frente al supermercado...', icon: Icons.place),
              ],
            ),
          ),
          const SizedBox(height: PiyiSpacing.xl),
          PiyiSection(
            title: 'Detalles',
            child: Column(
              children: [
                PiyiTextField(controller: _observationController, label: 'Observación', hint: 'Qué viste, hacia dónde iba, collar...', icon: Icons.notes, maxLines: 4),
                const SizedBox(height: PiyiSpacing.sm),
                PiyiTextField(controller: _photoUrlController, label: 'URL de foto opcional', icon: Icons.image),
              ],
            ),
          ),
          const SizedBox(height: PiyiSpacing.xl),
          PiyiPrimaryButton(label: 'Enviar avistamiento', icon: Icons.send, isLoading: _isLoading, onPressed: _submit),
        ],
      ),
    );
  }
}
