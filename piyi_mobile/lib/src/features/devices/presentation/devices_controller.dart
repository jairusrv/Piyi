import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/device_models.dart';
import '../data/devices_repository.dart';

final devicesProvider = FutureProvider.autoDispose<List<UserDevice>>((ref) {
  return ref.watch(devicesRepositoryProvider).getMyDevices();
});
