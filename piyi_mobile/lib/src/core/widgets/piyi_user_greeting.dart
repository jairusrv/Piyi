import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PiyiUserGreeting extends StatefulWidget {
  const PiyiUserGreeting({
    super.key,
    this.prefix = 'Hola',
  });

  final String prefix;

  @override
  State<PiyiUserGreeting> createState() => _PiyiUserGreetingState();
}

class _PiyiUserGreetingState extends State<PiyiUserGreeting> {
  static const _storage = FlutterSecureStorage();

  String _name = 'Usuario';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final values = <String?>[
      await _storage.read(key: 'firstName'),
      await _storage.read(key: 'name'),
      await _storage.read(key: 'fullName'),
      await _readNameFromToken(),
      await _storage.read(key: 'email'),
    ];

    final selected = values
        .whereType<String>()
        .map((x) => x.trim())
        .where((x) => x.isNotEmpty)
        .map(_cleanName)
        .firstOrNull;

    if (!mounted) return;

    setState(() {
      _name = selected ?? 'Usuario';
    });
  }

  Future<String?> _readNameFromToken() async {
    final token = await _storage.read(key: 'access_token') ??
        await _storage.read(key: 'token') ??
        await _storage.read(key: 'auth_token') ??
        await _storage.read(key: 'jwt');

    if (token == null || token.split('.').length < 2) {
      return null;
    }

    try {
      final payload = token.split('.')[1];
      final normalized = base64Url.normalize(payload);
      final jsonMap = jsonDecode(utf8.decode(base64Url.decode(normalized))) as Map<String, dynamic>;

      return (jsonMap['given_name'] ??
              jsonMap['firstName'] ??
              jsonMap['name'] ??
              jsonMap['unique_name'] ??
              jsonMap['email'])
          ?.toString();
    } catch (_) {
      return null;
    }
  }

  String _cleanName(String value) {
    var text = value.trim();

    if (text.contains('@')) {
      text = text.split('@').first;
    }

    if (text.contains(' ')) {
      text = text.split(' ').first;
    }

    if (text.isEmpty) {
      return 'Usuario';
    }

    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.prefix} $_name',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1F2D44),
          ),
    );
  }
}
