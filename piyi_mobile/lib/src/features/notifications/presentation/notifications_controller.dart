import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notification_models.dart';
import '../data/notifications_repository.dart';

final notificationsUnreadOnlyProvider = StateProvider<bool>((ref) => false);

final notificationsProvider = FutureProvider.autoDispose<List<UserNotification>>((ref) {
  final unreadOnly = ref.watch(notificationsUnreadOnlyProvider);
  return ref.watch(notificationsRepositoryProvider).getMyNotifications(unreadOnly: unreadOnly);
});
