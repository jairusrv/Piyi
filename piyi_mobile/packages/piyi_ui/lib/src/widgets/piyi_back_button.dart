import 'package:flutter/material.dart';

class PiyiBackButton extends StatelessWidget {
  const PiyiBackButton({
    super.key,
    this.onPressed,
    this.fallback,
  });

  final VoidCallback? onPressed;
  final VoidCallback? fallback;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Volver',
      icon: const Icon(Icons.arrow_back),
      onPressed: onPressed ??
          () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              fallback?.call();
            }
          },
    );
  }
}
