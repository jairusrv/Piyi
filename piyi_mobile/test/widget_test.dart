import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piyi_mobile/src/app/piyi_app.dart';

void main() {
  testWidgets('Piyi app starts', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PiyiApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
