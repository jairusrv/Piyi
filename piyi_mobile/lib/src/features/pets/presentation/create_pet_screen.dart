import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/pet_models.dart';
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

  Species? _selectedSpecies;
  Breed? _selectedBreed;
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

  Future<void> _save() async {
    if (_selectedSpecies == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una especie.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(petsRepositoryProvider).createPet(
            name: _nameController.text.trim(),
            speciesId: _selectedSpecies!.id,
            breedId: _selectedBreed?.id,
            color: _colorController.text.trim().isEmpty
                ? null
                : _colorController.text.trim(),
            sex: _sex,
            weightKg: num.tryParse(_weightController.text.trim()),
            isSterilized: _isSterilized,
          );

      ref.invalidate(petsListProvider);

      if (!mounted) return;
      context.go(PetsScreen.route);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final speciesAsync = ref.watch(speciesProvider);
    final breedsAsync = _selectedSpecies == null
        ? null
        : ref.watch(breedsProvider(_selectedSpecies!.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar mascota'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            speciesAsync.when(
              data: (species) => DropdownButtonFormField<Species>(
                value: _selectedSpecies,
                decoration: const InputDecoration(labelText: 'Especie'),
                items: species
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpecies = value;
                    _selectedBreed = null;
                  });
                },
              ),
              error: (error, _) => Text('Error cargando especies: $error'),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 16),
            if (breedsAsync != null)
              breedsAsync.when(
                data: (breeds) => DropdownButtonFormField<Breed>(
                  value: _selectedBreed,
                  decoration: const InputDecoration(labelText: 'Raza'),
                  items: breeds
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedBreed = value);
                  },
                ),
                error: (error, _) => Text('Error cargando razas: $error'),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(labelText: 'Color'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _sex,
              decoration: const InputDecoration(labelText: 'Sexo'),
              items: const [
                DropdownMenuItem(value: 'Unknown', child: Text('No indicar')),
                DropdownMenuItem(value: 'Male', child: Text('Macho')),
                DropdownMenuItem(value: 'Female', child: Text('Hembra')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _sex = value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Peso kg'),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: _isSterilized,
              title: const Text('Esterilizada/o'),
              onChanged: (value) {
                setState(() => _isSterilized = value);
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child: Text(_isLoading ? 'Guardando...' : 'Guardar mascota'),
            ),
          ],
        ),
      ),
    );
  }
}
