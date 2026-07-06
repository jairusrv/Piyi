import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/brand/piyi_brand.dart';

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

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage(PiyiBrand.logoAsset),
                  width: 240,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 12),
                Text(
                  PiyiBrand.slogan,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF31A997),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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
