import 'package:flutter/material.dart';

class PiyiCountryPhoneField extends StatefulWidget {
  const PiyiCountryPhoneField({
    super.key,
    required this.controller,
    this.initialDialCode = '+506',
    this.initialCountryCode = 'CR',
    this.label = 'Teléfono',
  });

  final TextEditingController controller;
  final String initialDialCode;
  final String initialCountryCode;
  final String label;

  @override
  State<PiyiCountryPhoneField> createState() => _PiyiCountryPhoneFieldState();
}

class _PiyiCountryPhoneFieldState extends State<PiyiCountryPhoneField> {
  late String _dialCode;
  late String _countryCode;

  final countries = const [
    ('CR', '🇨🇷', 'Costa Rica', '+506'),
    ('PA', '🇵🇦', 'Panamá', '+507'),
    ('NI', '🇳🇮', 'Nicaragua', '+505'),
    ('GT', '🇬🇹', 'Guatemala', '+502'),
    ('SV', '🇸🇻', 'El Salvador', '+503'),
    ('HN', '🇭🇳', 'Honduras', '+504'),
    ('MX', '🇲🇽', 'México', '+52'),
    ('CO', '🇨🇴', 'Colombia', '+57'),
    ('US', '🇺🇸', 'Estados Unidos', '+1'),
  ];

  @override
  void initState() {
    super.initState();
    _dialCode = widget.initialDialCode;
    _countryCode = widget.initialCountryCode;
  }

  String get _flag {
    return countries.firstWhere(
      (x) => x.$1 == _countryCode,
      orElse: () => countries.first,
    ).$2;
  }

  String get fullPhone {
    final raw = widget.controller.text.trim();
    if (raw.startsWith('+')) return raw;
    return '$_dialCode$raw';
  }

  Future<void> _selectCountry() async {
    final selected = await showModalBottomSheet<({String code, String flag, String name, String dial})>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                'Selecciona país',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            for (final c in countries)
              ListTile(
                leading: Text(c.$2, style: const TextStyle(fontSize: 28)),
                title: Text(c.$3),
                trailing: Text(c.$4, style: const TextStyle(fontWeight: FontWeight.w800)),
                onTap: () => Navigator.pop(context, (code: c.$1, flag: c.$2, name: c.$3, dial: c.$4)),
              ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() {
        _countryCode = selected.code;
        _dialCode = selected.dial;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        prefixIcon: InkWell(
          onTap: _selectCountry,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.only(left: 14, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_flag, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 20),
                const SizedBox(width: 4),
                Text(_dialCode, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
