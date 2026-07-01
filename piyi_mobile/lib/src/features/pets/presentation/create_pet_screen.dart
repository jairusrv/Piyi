import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/errors/api_error_message.dart';
import '../../uploads/data/uploads_repository.dart';
import '../data/pets_repository.dart';
import 'pets_controller.dart';
import 'pets_screen.dart';

class CreatePetScreen extends ConsumerStatefulWidget {
  const CreatePetScreen({super.key});

  static const route = '/pets/create';

  @override
  ConsumerState<CreatePetScreen> createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends ConsumerState<CreatePetScreen> {
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _weightController = TextEditingController();

  final _picker = ImagePicker();

  XFile? _selectedImage;
  String _speciesId = '';
  String _breedId = '';
  String _sex = 'Unknown';
  bool _isSterilized = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1600,
    );

    if (image == null) return;

    setState(() => _selectedImage = image);
  }

  Future<String?> _uploadSelectedImage() async {
    if (_selectedImage == null) return null;

    final result = await ref.read(uploadsRepositoryProvider).uploadImage(_selectedImage!.path);
    return result.url;
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      PiyiSnackBar.warning(context, 'El nombre de la mascota es requerido.');
      return;
    }

    if (_speciesId.isEmpty) {
      PiyiSnackBar.warning(context, 'Selecciona una especie.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final photoUrl = await _uploadSelectedImage();

      await ref.read(petsRepositoryProvider).createPet(
            name: name,
            speciesId: _speciesId,
            breedId: _breedId.isEmpty ? null : _breedId,
            sex: _sex,
            color: _emptyToNull(_colorController.text),
            weightKg: num.tryParse(_weightController.text.trim()),
            photoUrl: photoUrl,
            isSterilized: _isSterilized,
          );

      ref.invalidate(petsProvider);

      if (!mounted) return;

      PiyiSnackBar.success(context, 'Mascota registrada correctamente.');
      context.go(PetsScreen.route);
    } on DioException catch (e) {
      if (!mounted) return;
      PiyiSnackBar.error(context, ApiErrorMessage.fromDio(e, fallback: 'No se pudo registrar la mascota.'));
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
    final speciesAsync = ref.watch(speciesProvider);
    final breedsAsync = _speciesId.isEmpty
        ? const AsyncValue.data([])
        : ref.watch(breedsBySpeciesProvider(_speciesId));

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar mascota')),
      body: SafeArea(
        minimum: const EdgeInsets.all(PiyiSpacing.md),
        child: ListView(
          children: [
            PiyiBannerCard(
              icon: Icons.pets,
              title: 'Nueva mascota',
              subtitle: 'Crea su perfil digital con foto real.',
              color: PiyiColors.primary,
            ),
            const SizedBox(height: PiyiSpacing.xl),

            PiyiSection(
              title: 'Foto',
              child: PiyiCard(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundImage: _selectedImage == null ? null : FileImage(File(_selectedImage!.path)),
                      child: _selectedImage == null ? const Icon(Icons.pets, size: 42) : null,
                    ),
                    const SizedBox(height: PiyiSpacing.md),
                    PiyiSecondaryButton(
                      label: _selectedImage == null ? 'Seleccionar foto' : 'Cambiar foto',
                      icon: Icons.image,
                      onPressed: _pickImage,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: PiyiSpacing.xl),

            PiyiSection(
              title: 'Datos principales',
              child: Column(
                children: [
                  PiyiTextField(
                    controller: _nameController,
                    label: 'Nombre',
                    hint: 'Ej: Luna, Max, Nala...',
                    icon: Icons.pets,
                  ),
                  const SizedBox(height: PiyiSpacing.sm),
                  speciesAsync.when(
                    data: (species) => DropdownButtonFormField<String>(
                      value: _speciesId.isEmpty ? null : _speciesId,
                      decoration: const InputDecoration(
                        labelText: 'Especie',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: species
                          .map((item) => DropdownMenuItem<String>(value: item.id, child: Text(item.name)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _speciesId = value ?? '';
                          _breedId = '';
                        });
                      },
                    ),
                    error: (error, _) => PiyiAlertCard(
                      title: 'No pudimos cargar especies',
                      subtitle: ApiErrorMessage.fromObject(error),
                      actionLabel: 'Reintentar',
                      onTap: () => ref.invalidate(speciesProvider),
                    ),
                    loading: () => const PiyiLoadingCard(),
                  ),
                  const SizedBox(height: PiyiSpacing.sm),
                  breedsAsync.when(
                    data: (breeds) => DropdownButtonFormField<String>(
                      value: _breedId.isEmpty ? null : _breedId,
                      decoration: const InputDecoration(
                        labelText: 'Raza',
                        prefixIcon: Icon(Icons.cruelty_free),
                      ),
                      items: breeds
                          .map((item) => DropdownMenuItem<String>(value: item.id, child: Text(item.name)))
                          .toList(),
                      onChanged: (value) => setState(() => _breedId = value ?? ''),
                    ),
                    error: (error, _) => PiyiAlertCard(
                      title: 'No pudimos cargar razas',
                      subtitle: ApiErrorMessage.fromObject(error),
                      actionLabel: 'Reintentar',
                      onTap: () => ref.invalidate(breedsBySpeciesProvider(_speciesId)),
                    ),
                    loading: () => const PiyiLoadingCard(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: PiyiSpacing.xl),

            PiyiSection(
              title: 'Detalles',
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _sex,
                    decoration: const InputDecoration(labelText: 'Sexo', prefixIcon: Icon(Icons.wc)),
                    items: const [
                      DropdownMenuItem(value: 'Unknown', child: Text('No indicado')),
                      DropdownMenuItem(value: 'Male', child: Text('Macho')),
                      DropdownMenuItem(value: 'Female', child: Text('Hembra')),
                    ],
                    onChanged: (value) => setState(() => _sex = value ?? 'Unknown'),
                  ),
                  const SizedBox(height: PiyiSpacing.sm),
                  PiyiTextField(
                    controller: _colorController,
                    label: 'Color',
                    hint: 'Ej: Negro, café, blanco...',
                    icon: Icons.palette,
                  ),
                  const SizedBox(height: PiyiSpacing.sm),
                  PiyiTextField(
                    controller: _weightController,
                    label: 'Peso en kg',
                    hint: 'Ej: 8.5',
                    icon: Icons.monitor_weight,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: PiyiSpacing.sm),
                  SwitchListTile(
                    value: _isSterilized,
                    title: const Text('Esterilizada/o'),
                    subtitle: const Text('Indica si ya fue esterilizada/o.'),
                    onChanged: (value) => setState(() => _isSterilized = value),
                  ),
                ],
              ),
            ),

            const SizedBox(height: PiyiSpacing.xl),

            PiyiPrimaryButton(
              label: _selectedImage == null ? 'Guardar mascota' : 'Subir foto y guardar',
              icon: Icons.save,
              isLoading: _isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: PiyiSpacing.md),
            PiyiSecondaryButton(
              label: 'Cancelar',
              icon: Icons.close,
              onPressed: () => context.go(PetsScreen.route),
            ),
          ],
        ),
      ),
    );
  }
}
