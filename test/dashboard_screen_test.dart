import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:trade_tracker/main.dart';
import 'hive_mock.dart'; // make sure this defines MockHiveService

void main() {
  testWidgets('Dashboard smoke test with mock HiveService',
      (WidgetTester tester) async {
    final mockHiveService = MockHiveService();

    await tester.pumpWidget(
      MaterialApp(
        home: TradeTrackerApp(hiveService: mockHiveService),
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
