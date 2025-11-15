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

  setUpAll(() async {
    await initTestHive();
    registerAdapterSafely(PersonAdapter());
    registerAdapterSafely(SecFilingAdapter());

    await openTestBox<Person>('people');
    await openTestBox<SecFiling>('secFilings');
    await openTestBox('settings');
    await openTestBox('cikCache'); // ✅ ensure this is open for CIK lookups

    // ✅ initialize hiveService here
    hiveService = HiveService();
  });

  tearDownAll(() async {
    await disposeTestHive();
  });

  group('App smoke test', () {
    setUp(() async {
      final box = Hive.box<SecFiling>('secFilings');
      await box.clear();

      // ✅ Use the named Form 4 constructor with required cik
      final filing = SecFiling.form4(
        accessionNumber: '0000000000-25-000001',
        issuer: 'SmokeTest Corp',
        filingDate: '2025-11-13',
        source: 'test',
        cik: '0000000000', // ✅ required argument
        insiderName: 'Test Insider',
        insiderCik: '0000123456',
        transactionCode: 'P',
        transactionShares: 10,
        transactionPrice: 1.0,
      );

      await box.put(filing.id, filing);
    });

    testWidgets('App launches and shows Dashboard',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: DashboardScreen(hiveService: hiveService)),
      );

      expect(find.text('Trade Tracker Dashboard'), findsOneWidget);
      expect(find.text('SmokeTest Corp'), findsOneWidget);
    });
  });
}
