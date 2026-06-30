import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../devices/data/devices_repository.dart';
import '../../devices/presentation/devices_controller.dart';
import 'push_diagnostics_controller.dart';

class PushDiagnosticsScreen extends ConsumerStatefulWidget {
  const PushDiagnosticsScreen({super.key});

  static const route = '/push-diagnostics';

  @override
  ConsumerState<PushDiagnosticsScreen> createState() => _PushDiagnosticsScreenState();
}

class _PushDiagnosticsScreenState extends ConsumerState<PushDiagnosticsScreen> {
  bool _isRegistering = false;

  Future<void> _registerDevice() async {
    setState(() => _isRegistering = true);

    try {
      await ref.read(devicesRepositoryProvider).registerCurrentDevice();

      ref.invalidate(devicesProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispositivo registrado/actualizado.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registrando dispositivo: $e')),
      );
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final diagnosticsAsync = ref.watch(pushDiagnosticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnóstico push'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(pushDiagnosticsProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: diagnosticsAsync.when(
          data: (info) => ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Icon(
                        info.firebaseInitialized ? Icons.cloud_done : Icons.cloud_off,
                        size: 56,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        info.firebaseInitialized
                            ? 'Firebase inicializado'
                            : 'Firebase no configurado',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        info.firebaseInitialized
                            ? 'La app intentará usar token FCM real.'
                            : 'La app usará token DEV temporal hasta configurar Firebase.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Plataforma',
                value: info.platform,
                icon: Icons.phone_android,
              ),
              _InfoCard(
                title: 'Dispositivo',
                value: info.deviceName ?? 'No identificado',
                icon: Icons.devices,
              ),
              _InfoCard(
                title: 'Device ID local',
                value: info.deviceIdentifier,
                icon: Icons.fingerprint,
                copyable: true,
              ),
              _InfoCard(
                title: 'Push token',
                value: info.pushToken,
                icon: Icons.key,
                copyable: true,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _isRegistering ? null : _registerDevice,
                icon: const Icon(Icons.save),
                label: Text(_isRegistering ? 'Registrando...' : 'Registrar este dispositivo'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => ref.invalidate(pushDiagnosticsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar diagnóstico'),
              ),
            ],
          ),
          error: (error, _) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    this.copyable = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(value),
        trailing: copyable
            ? IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: value));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copiado.')),
                    );
                  }
                },
              )
            : null,
      ),
    );
  }
}
