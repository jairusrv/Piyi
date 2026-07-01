import 'package:flutter/material.dart';

import '../tokens/piyi_spacing.dart';
import 'piyi_back_button.dart';

class PiyiPageScaffold extends StatelessWidget {
  const PiyiPageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.showBackButton = true,
    this.onBack,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.all(PiyiSpacing.md),
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBackButton ? PiyiBackButton(onPressed: onBack) : null,
        title: Text(title),
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        minimum: padding,
        child: child,
      ),
    );
  }
}
