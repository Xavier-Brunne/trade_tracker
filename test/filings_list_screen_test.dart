import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';

import 'test_hive_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HiveService hiveService;
  late Box<SecFiling> filingsBox;

  setUpAll(() async {
    await initTestHive();

    // ✅ Register all adapters
    registerAdapterSafely(PersonAdapter());
    registerAdapterSafely(SecFilingAdapter());

    // ✅ Open all core boxes
    await openTestBox<Person>('people');
    filingsBox = await openTestBox<SecFiling>('secFilings');
    await openTestBox('settings');
    await openTestBox('cikCache');

    hiveService = HiveService();
  });

  tearDownAll(() async {
    await disposeTestHive();
  });

  group('DashboardScreen', () {
    setUp(() async {
      await filingsBox.clear();
    });

    testWidgets('renders multiple filings in list',
        (WidgetTester tester) async {
      await filingsBox.put(
        '1',
        SecFiling(
          id: '1',
          issuer: 'Demo Corp',
          filingDate: '2025-11-08',
          accessionNumber: '0000000001',
          formType: 'Form 4',
          reportDate: DateTime.now(),
          isSaved: true,
          source: 'mock',
          cik: '0000000000', // ✅ required argument
        ),
      );
      await filingsBox.put(
        '2',
        SecFiling(
          id: '2',
          issuer: 'Test Inc',
          filingDate: '2025-11-07',
          accessionNumber: '0000000002',
          formType: '10-K',
          reportDate: DateTime.now(),
          isSaved: false,
          source: 'mock',
          cik: '0000000000', // ✅ required argument
        ),
      );

      await tester.pumpWidget(
        MaterialApp(home: DashboardScreen(hiveService: hiveService)),
      );

      expect(find.text('Demo Corp'), findsOneWidget);
      expect(find.text('Form 4 • 2025-11-08'), findsOneWidget);
      expect(find.text('Test Inc'), findsOneWidget);
      expect(find.text('10-K • 2025-11-07'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('shows empty state when no filings exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: DashboardScreen(hiveService: hiveService)),
      );
      expect(find.byType(ListTile), findsNothing);
    });
  });
}
