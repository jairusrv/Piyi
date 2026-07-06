import 'package:flutter/material.dart';
import 'package:piyi_ui/piyi_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/brand/piyi_brand.dart';
import '../../../core/navigation/piyi_navigation_helper.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const route = '/help';

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: PiyiBrand.supportEmail,
      queryParameters: {
        'subject': 'Ayuda con Piyí',
      },
    );
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return PiyiPageScaffold(
      title: 'Ayuda',
      onBack: () => PiyiNavigationHelper.backOrHome(context),
      child: ListView(
        children: [
          PiyiBannerCard(
            icon: Icons.support_agent,
            title: '¿Necesitas ayuda?',
            subtitle: 'Estamos para ayudarte con el uso de Piyí.',
            color: PiyiColors.primary,
          ),
          const SizedBox(height: 20),
          PiyiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Correo de soporte', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 8),
                const Text(PiyiBrand.supportEmail),
                const SizedBox(height: 18),
                PiyiPrimaryButton(
                  label: 'Enviar correo',
                  icon: Icons.email,
                  onPressed: _sendEmail,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const PiyiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Preguntas frecuentes', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                SizedBox(height: 12),
                Text('• ¿Piyí cobra por usar la app? Por ahora la beta es gratuita.'),
                SizedBox(height: 8),
                Text('• ¿Puedo registrar varias mascotas? Sí.'),
                SizedBox(height: 8),
                Text('• ¿Puedo contactar negocios? Sí, Piyí muestra datos para contacto directo.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
