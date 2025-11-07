import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:trade_tracker/screens/sec_form4_screen.dart';
import 'hive_mock.dart'; // defines MockHiveService

void main() {
  testWidgets('SecForm4Screen renders with mock HiveService', (tester) async {
    final mockHiveService = MockHiveService();

    await tester.pumpWidget(
      MaterialApp(
        home: SecForm4Screen(hiveService: mockHiveService),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Form 4 Filings'), findsOneWidget);
  });
}
