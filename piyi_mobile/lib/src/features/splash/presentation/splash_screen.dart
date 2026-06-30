import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../auth/presentation/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const route = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      context.go(LoginScreen.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🐾',
              style: TextStyle(fontSize: 72),
            ),
            SizedBox(height: 16),
            Text(
              'Piyí',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 8),
            Text('La identidad digital de tu mascota'),
          ],
        ),
      ),
    );
  }
}
