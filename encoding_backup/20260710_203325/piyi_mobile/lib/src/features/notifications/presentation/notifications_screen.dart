import 'package:flutter/material.dart';
import 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notifications_repository.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  static const route = '/notifications';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadOnly = ref.watch(notificationsUnreadOnlyProvider);

    return Scaffold(
      appBar: AppBar(
        leading: PiyiAppBackButton.fallbackHome(context),
        title: const Text('Notificaciones'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(notificationsUnreadOnlyProvider.notifier).state = !unreadOnly;
              ref.invalidate(notificationsProvider);
            },
            icon: Icon(unreadOnly ? Icons.mark_email_unread : Icons.all_inbox),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: notificationsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      unreadOnly
                          ? 'No tienes notificaciones sin leer.'
                          : 'AÃƒÆ’Ã‚Âºn no tienes notificaciones.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(notificationsProvider),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(item.isRead ? Icons.notifications_none : Icons.notifications_active),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w900,
                        ),
                      ),
                      subtitle: Text('${item.body}\n${item.createdAt}'),
                      isThreeLine: true,
                      trailing: item.isRead
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.done),
                              onPressed: () async {
                                await ref.read(notificationsRepositoryProvider).markAsRead(item.id);
                                ref.invalidate(notificationsProvider);
                              },
                            ),
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
