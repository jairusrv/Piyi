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

  void _goBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
      return;
    }

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  bool _canShowBack(BuildContext context) {
    if (!showBackButton) return false;
    if (onBack != null) return true;
    return Navigator.of(context).canPop();
  }

  @override
  Widget build(BuildContext context) {
    final canBack = _canShowBack(context);

    return Scaffold(
      appBar: AppBar(
        leading: canBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _goBack(context),
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
