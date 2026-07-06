import 'package:flutter/material.dart';
import '../../core/navigation/piyi_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../lost_pets/presentation/report_lost_pet_screen.dart';
import 'pet_health_controller.dart';
import 'pets_controller.dart';
import '../data/pet_health_repository.dart';

class PetDetailScreen extends ConsumerWidget {
  const PetDetailScreen({super.key, required this.petId});

  static const route = '/pets/:id';
  static String path(String id) => '/pets/$id';

  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petDetailProvider(petId));

    return petAsync.when(
      data: (pet) => DefaultTabController(
        length: 5,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
        leading: PiyiBackButton.fallbackHome(context),
        expandedHeight: 260,
                  pinned: true,
                  title: Text(pet.name),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _PetProfileHeader(pet: pet),
                  ),
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
              ];
            },
            body: TabBarView(
              children: [
                _InfoTab(pet: pet),
                _QrTab(petId: petId),
                _VaccinesTab(petId: petId),
                _RemindersTab(petId: petId),
                _AppointmentsTab(petId: petId),
              ],
            ),
          ),
        ),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(
        leading: PiyiBackButton.fallbackHome(context),
        title: const Text('Mi mascota')),
        body: Center(child: Text('Error: $error')),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _PetProfileHeader extends StatelessWidget {
  const _PetProfileHeader({required this.pet});

  final dynamic pet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.90),
            theme.colorScheme.secondary.withOpacity(0.90),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.white,
            backgroundImage: pet.photoUrl == null ? null : NetworkImage(pet.photoUrl),
            child: pet.photoUrl == null
                ? Text(
                    pet.name.isEmpty ? 'ðŸ¾' : pet.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            pet.name,
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            '${pet.speciesName}${pet.breedName == null ? '' : ' Â· ${pet.breedName}'}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
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
      minimum: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _ActionPanel(petId: pet.id),
          const SizedBox(height: 12),
          _HealthSummaryCard(pet: pet),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.pets, label: 'Especie', value: pet.speciesName),
          _InfoRow(icon: Icons.category, label: 'Raza', value: pet.breedName ?? 'No indicada'),
          _InfoRow(icon: Icons.palette, label: 'Color', value: pet.color ?? 'No indicado'),
          _InfoRow(icon: Icons.wc, label: 'Sexo', value: pet.sex),
          _InfoRow(icon: Icons.info, label: 'Estado', value: pet.status),
          _InfoRow(
            icon: Icons.monitor_weight,
            label: 'Peso',
            value: pet.weightKg == null ? 'No indicado' : '${pet.weightKg} kg',
          ),
          _InfoRow(
            icon: Icons.health_and_safety,
            label: 'Esterilizada/o',
            value: pet.isSterilized ? 'SÃ­' : 'No',
          ),
        ],
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  const _ActionPanel({required this.petId});

  final String petId;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Acciones rÃ¡pidas', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ActionChip(avatar: const Icon(Icons.qr_code_2, size: 18), label: const Text('QR'), onPressed: () {}),
                ActionChip(avatar: const Icon(Icons.vaccines, size: 18), label: const Text('Vacuna'), onPressed: () {}),
                ActionChip(avatar: const Icon(Icons.event, size: 18), label: const Text('Cita'), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => context.go(ReportLostPetScreen.path(petId)),
              icon: const Icon(Icons.location_on),
              label: const Text('Reportar como perdida'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthSummaryCard extends StatelessWidget {
  const _HealthSummaryCard({required this.pet});

  final dynamic pet;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.favorite, size: 38),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Resumen de salud', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(pet.isSterilized ? 'Esterilizada/o Â· estado ${pet.status}' : 'Sin esterilizar Â· estado ${pet.status}'),
                ],
              ),
            ),
          ],
        ),
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
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.qr_code_2, size: 90),
                      const SizedBox(height: 16),
                      const Text('Tu mascota aÃºn no tiene QR', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      const Text('Genera una identidad digital para que puedan contactarte si se pierde.', textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () async {
                          await ref.read(petHealthRepositoryProvider).generateQr(petId);
                          ref.invalidate(petQrProvider(petId));
                        },
                        icon: const Icon(Icons.qr_code),
                        label: const Text('Generar QR'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.qr_code_2, size: 170),
                    const SizedBox(height: 20),
                    Text(qr.code, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    SelectableText(qr.publicUrl, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Text('Escaneos: ${qr.scanCount}'),
                  ],
                ),
              ),
            ),
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
      emptyIcon: Icons.vaccines,
      emptyText: 'No hay vacunas registradas.',
      itemBuilder: (vaccine) => ListTile(
        leading: const Icon(Icons.vaccines),
        title: Text(vaccine.name),
        subtitle: Text('Aplicada: ${vaccine.appliedDate ?? 'No indicada'}\\nPrÃ³xima: ${vaccine.nextDueDate ?? 'No indicada'}'),
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
      emptyIcon: Icons.notifications_none,
      emptyText: 'No hay recordatorios.',
      itemBuilder: (reminder) => ListTile(
        leading: Icon(reminder.isCompleted ? Icons.check_circle : Icons.notifications),
        title: Text(reminder.title),
        subtitle: Text('${reminder.type}\\n${reminder.reminderDate}'),
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
      emptyIcon: Icons.event_available,
      emptyText: 'No hay citas registradas.',
      itemBuilder: (appointment) => ListTile(
        leading: const Icon(Icons.event),
        title: Text(appointment.title),
        subtitle: Text('${appointment.type} Â· ${appointment.status}\\n${appointment.appointmentDateTime}\\n${appointment.placeName ?? ''}'),
      ),
    );
  }
}

class _AsyncList<T> extends StatelessWidget {
  const _AsyncList({
    required this.asyncValue,
    required this.emptyText,
    required this.emptyIcon,
    required this.itemBuilder,
  });

  final AsyncValue<List<T>> asyncValue;
  final String emptyText;
  final IconData emptyIcon;
  final Widget Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: asyncValue.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(emptyIcon, size: 64),
                      const SizedBox(height: 12),
                      Text(emptyText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.only(bottom: 10),
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
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      ),
    );
  }
}
