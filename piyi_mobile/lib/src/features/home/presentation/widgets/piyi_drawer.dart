import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/brand/piyi_brand.dart';

class PiyiDrawer extends StatelessWidget {
  const PiyiDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(PiyiBrand.logoAsset, width: 150),
            const SizedBox(height: 8),
            const Text(
              PiyiBrand.slogan,
              style: TextStyle(color: Color(0xFF31A997), fontWeight: FontWeight.w600),
            ),
            const Divider(height: 32),
            _item(context, Icons.home, 'Inicio', '/home'),
            _item(context, Icons.pets, 'Mis mascotas', '/pets'),
            _item(context, Icons.location_on, 'Mascotas perdidas', '/lost-pets'),
            _item(context, Icons.store, 'Negocios', '/businesses'),
            _item(context, Icons.map, 'Mapa', '/map'),
            _item(context, Icons.settings, 'Configuración', '/profile/settings'),
            const Spacer(),
            const Divider(),
            _item(context, Icons.help_outline, 'Ayuda', '/help'),
            _item(context, Icons.info_outline, 'Acerca de', '/about'),
            _item(context, Icons.logout, 'Cerrar sesión', '/logout'),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
