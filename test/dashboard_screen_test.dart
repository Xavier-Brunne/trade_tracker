import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';
import 'test_helpers.dart';

void main() {
  setUp(() async => await initTestHive(['people']));
  tearDown(() async => await disposeTestHive());

  testWidgets('Dashboard shows one FAB', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
