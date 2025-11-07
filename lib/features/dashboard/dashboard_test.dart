import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_tracker/main.dart';
import 'package:trade_tracker/services/hive_service.dart';

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    const hiveService = HiveService();

    await tester.pumpWidget(
      const MaterialApp(
        // ✅ add const for performance
        home: TradeTrackerApp(hiveService: hiveService),
      ),
    );

    // Wait for splash transition
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Basic sanity checks
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });
}
