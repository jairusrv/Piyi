import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/navigation/piyi_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/devices_repository.dart';
import 'devices_controller.dart';

class DevicesScreen extends ConsumerStatefulWidget {
  const DevicesScreen({super.key});

  static const route = '/devices';

  @override
  ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends ConsumerState<DevicesScreen> {
  bool _isRegistering = false;

  Future<void> _register() async {
    setState(() => _isRegistering = true);

    try {
      await ref.read(devicesRepositoryProvider).registerCurrentDevice();

      ref.invalidate(devicesProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispositivo registrado correctamente.')),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      var message = 'No se pudo registrar el dispositivo.';

      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (data != null) {
        message = data.toString();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  Future<void> _deactivate(String deviceId) async {
    try {
      await ref.read(devicesRepositoryProvider).deactivateDevice(deviceId);
      ref.invalidate(devicesProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispositivo desactivado.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(devicesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: PiyiBackButton.fallbackHome(context),
        title: const Text('Dispositivos'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isRegistering ? null : _register,
        icon: const Icon(Icons.phone_android),
        label: Text(_isRegistering ? 'Registrando...' : 'Registrar este'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: devicesAsync.when(
          data: (devices) {
            if (devices.isEmpty) {
              return Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.notifications_off, size: 64),
                        const SizedBox(height: 12),
                        const Text(
                          'No hay dispositivos registrados.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _register,
                          icon: const Icon(Icons.phone_android),
                          label: const Text('Registrar este dispositivo'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(devicesProvider),
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(device.isActive ? Icons.phone_android : Icons.mobile_off),
                      title: Text(
                        device.deviceName ?? device.platform,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      subtitle: Text(
                        '${device.platform}\nActivo: ${device.isActive ? 'SÃ­' : 'No'}\nÃšltima vez: ${device.lastSeenAt ?? 'No indicado'}',
                      ),
                      isThreeLine: true,
                      trailing: device.isActive
                          ? IconButton(
                              icon: const Icon(Icons.block),
                              onPressed: () => _deactivate(device.id),
                            )
                          : null,
                    ),
                  );
                },
              ),
            );
          },
          error: (error, _) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
