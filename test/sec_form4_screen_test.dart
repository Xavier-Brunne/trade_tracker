import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:trade_tracker/screens/sec_form4_screen.dart';
import 'test_helpers.dart'; // shared Hive setup/teardown

void main() {
  // Initialise Hive with the 'filings' box used by the SEC Form 4 screen
  setUp(() async => await initTestHive(['filings']));
  tearDown(() async => await disposeTestHive());

  testWidgets('SEC Form 4 screen shows two FABs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SecForm4Screen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsNWidgets(2));
  });

  testWidgets('Tapping first FAB triggers navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SecForm4Screen(),
        routes: {
          '/filings': (context) => const Scaffold(body: Text('Filings Screen')),
        },
      ),
    );

    await tester.pumpAndSettle();

    // Tap the first FAB (assuming it's the one that navigates)
    final fab = find.byType(FloatingActionButton).first;
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Verify navigation occurred
    expect(find.text('Filings Screen'), findsOneWidget);
  });
}
