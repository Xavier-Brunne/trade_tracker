import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/models/settings.dart';
import 'package:trade_tracker/models/cik_cache_entry.dart';
import 'package:trade_tracker/models/trade.dart';
import 'package:trade_tracker/models/portfolio.dart';
import 'package:trade_tracker/models/user_prefs.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';
import 'package:trade_tracker/features/filing_detail/filing_detail_screen.dart';
import 'package:trade_tracker/hive_adapters.dart';

import 'test_hive_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HiveService hiveService;
  late Box<SecFiling> filingsBox;

  setUpAll(() async {
    // Initialise Hive test environment
    await initTestHive();

    // Register all adapters centrally
    registerHiveAdapters();

    // Open all relevant boxes
    await openTestBox<Person>('people');
    filingsBox = await openTestBox<SecFiling>('secFilings');
    await openTestBox<Settings>('settings');
    await openTestBox<CikCacheEntry>('cikCache');
    await openTestBox<Trade>('trades');
    await openTestBox<Portfolio>('portfolios');
    await openTestBox<UserPrefs>('userPrefs');

    hiveService = HiveService();
  });

  tearDownAll(() async {
    // Dispose Hive test environment
    await disposeTestHive();
  });

  group('DashboardScreen', () {
    setUp(() async {
      await filingsBox.clear();
    });

    testWidgets('renders single filing', (WidgetTester tester) async {
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

      await tester.pumpWidget(
        MaterialApp(home: DashboardScreen(hiveService: hiveService)),
      );

      expect(find.text('Trade Tracker Dashboard'), findsOneWidget);
      expect(find.text('Demo Corp'), findsOneWidget);
      expect(find.text('Form 4 • 2025-11-08'), findsOneWidget);
    });

    testWidgets('renders multiple filings', (WidgetTester tester) async {
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
      // Optional: check for empty state text if implemented
      // expect(find.text('No filings available'), findsOneWidget);
    });

    testWidgets('navigates to FilingDetailScreen', (WidgetTester tester) async {
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

      await tester.pumpWidget(
        MaterialApp(home: DashboardScreen(hiveService: hiveService)),
      );

      expect(find.text('Demo Corp'), findsOneWidget);

      await tester.tap(find.text('Demo Corp'));
      await tester.pumpAndSettle();

      expect(find.byType(FilingDetailScreen), findsOneWidget);
      expect(find.text('Demo Corp'), findsOneWidget);
      expect(find.text('Form 4'), findsOneWidget);
      expect(find.text('2025-11-08'), findsOneWidget);
      expect(find.text('0000000001'), findsOneWidget);
    });
  });
}
