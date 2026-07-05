import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piyi_ui/piyi_ui.dart';

import '../../../core/config/app_config.dart';
import '../../auth/data/auth_session_manager.dart';
import '../../auth/presentation/login_screen.dart';
import '../../home/presentation/home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const route = '/';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_resolveSession);
  }

  Future<void> _resolveSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));

    final hasSession =
        await ref.read(authSessionManagerProvider).hasStoredSession();

    if (!mounted) return;

    if (hasSession) {
      context.go(HomeScreen.route);
    } else {
      context.go(LoginScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PiyiColors.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(PiyiSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 116,
                  height: 116,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 68,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: PiyiSpacing.xl),
                const Text(
                  AppConfig.displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: PiyiSpacing.sm),
                Text(
                  'El hogar digital de tus mascotas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.92),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: PiyiSpacing.xxl),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
