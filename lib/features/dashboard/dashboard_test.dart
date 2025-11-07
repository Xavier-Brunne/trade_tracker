import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:trade_tracker/main.dart';
import 'package:trade_tracker/services/hive_service.dart';

// You can use a real HiveService or a mock depending on your setup.
// For a simple smoke test, a real HiveService is fine.
void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    final hiveService = HiveService();

    await tester.pumpWidget(
      MaterialApp(
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
