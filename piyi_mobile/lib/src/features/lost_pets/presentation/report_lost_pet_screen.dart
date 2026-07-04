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
import '../../pets/presentation/pet_detail_screen.dart';
import '../data/lost_pets_repository.dart';

class ReportLostPetScreen extends ConsumerStatefulWidget {
  const ReportLostPetScreen({super.key, required this.petId});

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

  CurrentLocationResult? _location;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      PiyiSnackBar.warning(context, 'Título y descripción son requeridos.');
      return;
    }

    if (_location == null) {
      PiyiSnackBar.warning(context, 'Usa tu ubicación actual para publicar el reporte.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(lostPetsRepositoryProvider).reportLostPet(
            petId: widget.petId,
            title: title,
            description: description,
            lastSeenAddress: _emptyToNull(_addressController.text) ?? _location?.address ?? _location?.placeLabel,
            lastSeenLatitude: _location?.latitude,
            lastSeenLongitude: _location?.longitude,
            contactPhone: _emptyToNull(_phoneController.text),
            rewardAmount: num.tryParse(_rewardController.text.trim()),
          );

      if (!mounted) return;

      PiyiSnackBar.success(context, 'Reporte creado correctamente.');
      context.go(PetDetailScreen.path(widget.petId));
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
      title: 'Reportar perdida',
      onBack: () => PiyiNavigationHelper.backOrHome(context),
      child: ListView(
        children: [
          PiyiBannerCard(
            icon: Icons.location_on,
            title: 'Ayudemos a encontrarla',
            subtitle: 'Usaremos tu ubicación actual como último lugar visto.',
            color: PiyiColors.error,
          ),
          const SizedBox(height: PiyiSpacing.xl),
          PiyiSection(
            title: 'Reporte',
            child: Column(
              children: [
                PiyiTextField(controller: _titleController, label: 'Título', hint: 'Ej: Se perdió Max en Cartago', icon: Icons.campaign),
                const SizedBox(height: PiyiSpacing.sm),
                PiyiTextField(controller: _descriptionController, label: 'Descripción', hint: 'Color, tamaño, señas particulares...', icon: Icons.notes, maxLines: 4),
                const SizedBox(height: PiyiSpacing.sm),
                PiyiTextField(controller: _addressController, label: 'Referencia del lugar', hint: 'Ej: Cerca del parque...', icon: Icons.place),
              ],
            ),
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
                  PiyiCurrentLocationCard(location: _location!, title: 'Último lugar visto'),
                ],
              ],
            ),
          ),
          const SizedBox(height: PiyiSpacing.xl),
          PiyiSection(
            title: 'Contacto',
            child: Column(
              children: [
                PiyiTextField(controller: _phoneController, label: 'Teléfono de contacto', icon: Icons.phone, keyboardType: TextInputType.phone),
                const SizedBox(height: PiyiSpacing.sm),
                PiyiTextField(controller: _rewardController, label: 'Recompensa opcional', icon: Icons.card_giftcard, keyboardType: TextInputType.number),
              ],
            ),
          ),
          const SizedBox(height: PiyiSpacing.xl),
          PiyiPrimaryButton(label: 'Publicar reporte', icon: Icons.campaign, isLoading: _isLoading, onPressed: _submit),
        ],
      ),
    );
  }
}
