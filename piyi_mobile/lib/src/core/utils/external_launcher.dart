import 'package:url_launcher/url_launcher.dart';

class ExternalLauncher {
  static Future<void> callPhone(String? phone) async {
    final clean = _cleanPhone(phone);
    if (clean == null) return;

    await _launch(Uri.parse('tel:$clean'));
  }

  static Future<void> openWhatsApp(String? phone) async {
    final clean = _cleanPhone(phone);
    if (clean == null) return;

    await _launch(Uri.parse('https://wa.me/$clean'));
  }

  static Future<void> openMaps({
    num? latitude,
    num? longitude,
    String? query,
  }) async {
    Uri uri;

    if (latitude != null && longitude != null) {
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    } else {
      final encoded = Uri.encodeComponent(query ?? '');
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
    }

    await _launch(uri);
  }

  static String? _cleanPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    var clean = value.replaceAll(RegExp(r'[^0-9+]'), '');

    if (clean.startsWith('00')) {
      clean = clean.substring(2);
    }

    if (clean.startsWith('+')) {
      clean = clean.substring(1);
    }

    if (clean.length == 8) {
      clean = '506$clean';
    }

    return clean;
  }

  static Future<void> _launch(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir: $uri');
    }
  }
}
