import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pet_health_controller.dart';
import 'pets_controller.dart';
import '../data/pet_health_repository.dart';

class PetDetailScreen extends ConsumerWidget {
  const PetDetailScreen({
    super.key,
    required this.petId,
  });

  static const route = '/pets/:id';
  static String path(String id) => '/pets/$id';

  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petDetailProvider(petId));

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi mascota'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Info'),
              Tab(text: 'QR'),
              Tab(text: 'Vacunas'),
              Tab(text: 'Recordatorios'),
              Tab(text: 'Citas'),
            ],
          ),
        ),
        body: petAsync.when(
          data: (pet) => TabBarView(
            children: [
              _InfoTab(pet: pet),
              _QrTab(petId: petId),
              _VaccinesTab(petId: petId),
              _RemindersTab(petId: petId),
              _AppointmentsTab(petId: petId),
            ],
          ),
          error: (error, _) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  const _InfoTab({required this.pet});

  final dynamic pet;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(24),
      child: ListView(
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              child: Text(
                pet.name.isEmpty ? '🐾' : pet.name[0],
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            pet.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          _InfoRow(label: 'Especie', value: pet.speciesName),
          _InfoRow(label: 'Raza', value: pet.breedName ?? 'No indicada'),
          _InfoRow(label: 'Color', value: pet.color ?? 'No indicado'),
          _InfoRow(label: 'Sexo', value: pet.sex),
          _InfoRow(label: 'Estado', value: pet.status),
        ],
      ),
    );
  }
}

class _QrTab extends ConsumerWidget {
  const _QrTab({required this.petId});

  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrAsync = ref.watch(petQrProvider(petId));

    return SafeArea(
      minimum: const EdgeInsets.all(24),
      child: qrAsync.when(
        data: (qr) {
          if (qr == null) {
            return Center(
              child: FilledButton.icon(
                onPressed: () async {
                  await ref.read(petHealthRepositoryProvider).generateQr(petId);
                  ref.invalidate(petQrProvider(petId));
                },
                icon: const Icon(Icons.qr_code),
                label: const Text('Generar QR'),
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_2, size: 160),
              const SizedBox(height: 20),
              Text(qr.code, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(qr.publicUrl, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text('Escaneos: ${qr.scanCount}'),
            ],
          );
        },
        error: (error, _) => Center(child: Text('Error QR: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _VaccinesTab extends ConsumerWidget {
  const _VaccinesTab({required this.petId});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(petVaccinesProvider(petId));

    return _AsyncList(
      asyncValue: async,
      emptyText: 'No hay vacunas registradas.',
      itemBuilder: (vaccine) => ListTile(
        leading: const Icon(Icons.vaccines),
        title: Text(vaccine.name),
        subtitle: Text('Aplicada: ${vaccine.appliedDate ?? 'No indicada'}\nPróxima: ${vaccine.nextDueDate ?? 'No indicada'}'),
      ),
    );
  }
}

class _RemindersTab extends ConsumerWidget {
  const _RemindersTab({required this.petId});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(petRemindersProvider(petId));

    return _AsyncList(
      asyncValue: async,
      emptyText: 'No hay recordatorios.',
      itemBuilder: (reminder) => ListTile(
        leading: Icon(reminder.isCompleted ? Icons.check_circle : Icons.notifications),
        title: Text(reminder.title),
        subtitle: Text('${reminder.type}\n${reminder.reminderDate}'),
      ),
    );
  }
}

class _AppointmentsTab extends ConsumerWidget {
  const _AppointmentsTab({required this.petId});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(petAppointmentsProvider(petId));

    return _AsyncList(
      asyncValue: async,
      emptyText: 'No hay citas registradas.',
      itemBuilder: (appointment) => ListTile(
        leading: const Icon(Icons.event),
        title: Text(appointment.title),
        subtitle: Text('${appointment.type} · ${appointment.status}\n${appointment.appointmentDateTime}\n${appointment.placeName ?? ''}'),
      ),
    );
  }
}

class _AsyncList<T> extends StatelessWidget {
  const _AsyncList({
    required this.asyncValue,
    required this.emptyText,
    required this.itemBuilder,
  });

  final AsyncValue<List<T>> asyncValue;
  final String emptyText;
  final Widget Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: asyncValue.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(emptyText));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => Card(
              child: itemBuilder(items[index]),
            ),
          );
        },
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}
