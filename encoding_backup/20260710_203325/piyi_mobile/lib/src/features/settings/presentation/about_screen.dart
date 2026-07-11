import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:piyi_ui/piyi_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/brand/piyi_brand.dart';
import '../../../core/navigation/piyi_navigation_helper.dart';
import '../../../core/widgets/piyi_logo_header.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  static const route = '/about';

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      if (mounted) setState(() => _info = value);
    });
  }

  Future<void> _openPrivacy() async {
    final uri = Uri.parse('${PiyiBrand.apiUrl}/privacy');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return PiyiPageScaffold(
      title: 'Acerca de',
      onBack: () => PiyiNavigationHelper.backOrHome(context),
      child: ListView(
        children: [
          const PiyiLogoHeader(width: 180),
          const SizedBox(height: 24),
          PiyiCard(
            child: Column(
              children: [
                _row('App', PiyiBrand.displayName),
                _row('VersiÃ³n', _info?.version ?? '0.2.1'),
                _row('Build', _info?.buildNumber ?? '21'),
                _row('API', PiyiBrand.apiUrl),
                _row('Desarrollador', 'Jairo Rivera'),
                _row('Soporte', PiyiBrand.supportEmail),
                const SizedBox(height: 16),
                PiyiPrimaryButton(
                  label: 'Ver polÃ­tica de privacidad',
                  icon: Icons.privacy_tip,
                  onPressed: _openPrivacy,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Â© 2026 PiyÃ­. Todos los derechos reservados.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
