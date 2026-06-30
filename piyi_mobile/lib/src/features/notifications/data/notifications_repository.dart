import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'notification_models.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(ref.watch(dioProvider));
});

class NotificationsRepository {
  NotificationsRepository(this._dio);

  final Dio _dio;

  Future<List<UserNotification>> getMyNotifications({
    bool unreadOnly = false,
  }) async {
    final response = await _dio.get(
      '/api/users/me/notifications',
      queryParameters: {
        'unreadOnly': unreadOnly,
      },
    );

    final data = response.data as List<dynamic>;
    return data.map((x) => UserNotification.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _dio.put('/api/users/me/notifications/$notificationId/read');
  }
}
