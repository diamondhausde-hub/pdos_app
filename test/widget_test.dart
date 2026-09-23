import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pdos_app/core/widgets/glass_card.dart';

void main() {
  testWidgets('GlassCard renders its child and handles taps', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassCard(
            variant: GlassVariant.primary,
            onTap: () => tapped = true,
            child: const Text('card content'),
          ),
        ),
      ),
    );

    expect(find.text('card content'), findsOneWidget);

    await tester.tap(find.text('card content'));
    expect(tapped, isTrue);
  });
}
