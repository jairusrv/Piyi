import 'package:dio/dio.dart';

import '../../features/auth/data/auth_session_store.dart';

class AuthSessionInterceptor extends Interceptor {
  AuthSessionInterceptor(this._store);

  final AuthSessionStore _store;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _store.getAccessToken();

    if (token != null && token.trim().isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
