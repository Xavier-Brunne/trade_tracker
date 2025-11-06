import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:trade_tracker/main.dart'; // Ensure MyApp is defined here

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Wait for splash transition
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Basic sanity checks
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });
}
