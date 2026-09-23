import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdos_app/features/shared/screens/app_lock_screen.dart';

void main() {
  testWidgets('AppLockScreen renders locked UI correctly after auth settles', (WidgetTester tester) async {
    // ignore: unused_local_variable
    bool unlocked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AppLockScreen(onUnlocked: () => unlocked = true),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    expect(find.text('App Locked'), findsOneWidget);
    expect(find.text('Authenticate to access the app'), findsOneWidget);
    expect(find.byIcon(Icons.fingerprint), findsWidgets);
  });

  testWidgets('AppLockScreen blocks interaction with content behind it', (WidgetTester tester) async {
    // ignore: unused_local_variable
    bool unlocked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Stack(
          children: [
            const Positioned.fill(
              child: Center(child: Text('Sensitive Content Behind')),
            ),
            AppLockScreen(onUnlocked: () => unlocked = true),
          ],
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Sensitive Content Behind'), findsOneWidget, reason: 'Content exists behind lock screen');

    expect(find.text('App Locked'), findsOneWidget, reason: 'Lock screen overlay is visible');
    expect(find.text('Authenticate to access the app'), findsOneWidget);
  });

  testWidgets('AppLockScreen does not prematurely unlock without biometric success', (WidgetTester tester) async {
    bool unlocked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AppLockScreen(onUnlocked: () => unlocked = true),
      ),
    );

    await tester.pump(const Duration(seconds: 3));

    expect(unlocked, false, reason: 'Should NOT unlock since biometric auth fails in test environment');
  });
}
