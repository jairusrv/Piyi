import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_token_store.dart';

final sessionManagerProvider = Provider<SessionManager>((ref) {
  return SessionManager(ref.watch(authTokenStoreProvider));
});

final hasStoredSessionProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(sessionManagerProvider).hasValidStoredSession();
});

class SessionManager {
  SessionManager(this._tokenStore);

  final AuthTokenStore _tokenStore;

  Future<bool> hasValidStoredSession() async {
    final token = await _tokenStore.getAccessToken();

    if (token == null || token.trim().isEmpty) {
      return false;
    }

    // Validación mínima local.
    // Más adelante agregaremos /api/auth/me para validar expiración real contra servidor.
    return true;
  }

  Future<void> logout() async {
    await _tokenStore.clearSession();
  }
}
