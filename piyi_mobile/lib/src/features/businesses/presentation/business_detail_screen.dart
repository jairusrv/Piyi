import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/external_launcher.dart';
import 'businesses_controller.dart';

class BusinessDetailScreen extends ConsumerWidget {
  const BusinessDetailScreen({
    super.key,
    required this.businessId,
  });

  static const route = '/businesses/:id';
  static String path(String id) => '/businesses/$id';

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessAsync = ref.watch(businessDetailProvider(businessId));

    return Scaffold(
      appBar: AppBar(title: const Text('Negocio')),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: businessAsync.when(
          data: (business) => ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: business.logoUrl == null ? null : NetworkImage(business.logoUrl!),
                        child: business.logoUrl == null ? const Icon(Icons.store, size: 42) : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              business.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                            ),
                          ),
                          if (business.isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(business.businessTypeName ?? 'Servicio para mascotas'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (business.description != null)
                _InfoCard(icon: Icons.info, title: 'Descripción', subtitle: business.description!),
              _InfoCard(icon: Icons.location_on, title: 'Dirección', subtitle: business.address ?? 'No indicada'),
              _InfoCard(icon: Icons.location_city, title: 'Zona', subtitle: '${business.city ?? ''} ${business.region ?? ''} ${business.country ?? ''}'.trim()),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        try {
                          await ExternalLauncher.callPhone(business.phone);
                        } catch (e) {
                          _showError(context, 'No se pudo llamar.');
                        }
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Llamar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        try {
                          await ExternalLauncher.openWhatsApp(business.whatsApp ?? business.phone);
                        } catch (e) {
                          _showError(context, 'No se pudo abrir WhatsApp.');
                        }
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('WhatsApp'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: () async {
                  try {
                    await ExternalLauncher.openMaps(
                      latitude: business.latitude,
                      longitude: business.longitude,
                      query: business.address ?? business.name,
                    );
                  } catch (e) {
                    _showError(context, 'No se pudo abrir el mapa.');
                  }
                },
                icon: const Icon(Icons.directions),
                label: const Text('Cómo llegar'),
              ),
              const SizedBox(height: 20),
              const Text('Servicios', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              if (business.services.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text('Este negocio aún no tiene servicios registrados.'),
                  ),
                )
              else
                ...business.services.map((service) {
                  final price = service.priceFrom == null
                      ? ''
                      : 'Desde ₡${service.priceFrom}${service.priceTo == null ? '' : ' hasta ₡${service.priceTo}'}';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.pets),
                      title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: Text('${service.description ?? ''}${price.isEmpty ? '' : '\n$price'}'),
                    ),
                  );
                }),
              const SizedBox(height: 20),
              const Text('Horario', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              if (business.schedules.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text('Horario no indicado.'),
                  ),
                )
              else
                ...business.schedules.map((schedule) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(_dayName(schedule.dayOfWeek)),
                      subtitle: Text(schedule.isClosed ? 'Cerrado' : '${schedule.opensAt ?? ''} - ${schedule.closesAt ?? ''}'),
                    ),
                  );
                }),
              if (business.photos.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text('Fotos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 130,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: business.photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final photo = business.photos[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(photo.photoUrl, width: 130, height: 130, fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
          error: (error, _) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static String _dayName(int day) {
    switch (day) {
      case 0:
        return 'Domingo';
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      default:
        return 'Día';
    }
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    if (subtitle.trim().isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
