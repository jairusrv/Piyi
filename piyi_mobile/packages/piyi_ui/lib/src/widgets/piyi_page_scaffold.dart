import 'package:flutter/material.dart';

import '../tokens/piyi_spacing.dart';

class PiyiPageScaffold extends StatelessWidget {
  const PiyiPageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.onBack,
    this.padding = const EdgeInsets.all(PiyiSpacing.md),
    this.showBackButton = true,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final EdgeInsetsGeometry padding;
  final bool showBackButton;

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
      return;
    }

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                tooltip: 'Volver',
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _handleBack(context),
              )
            : null,
        title: Text(title),
        actions: actions,
      ),
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
