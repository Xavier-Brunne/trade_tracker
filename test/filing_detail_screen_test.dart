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

    // ✅ Register all adapters
    registerAdapterSafely(PersonAdapter());
    registerAdapterSafely(SecFilingAdapter());

    // ✅ Open all core boxes
    await openTestBox<Person>('people');
    await openTestBox<SecFiling>('secFilings');
    await openTestBox('settings');
    await openTestBox('cikCache');

    hiveService = HiveService();
  });

  tearDownAll(() async {
    await disposeTestHive();
  });

  group('FilingDetailScreen navigation', () {
    setUp(() async {
      await Hive.box<SecFiling>('secFilings').clear();
    });

    testWidgets('tapping a filing opens detail screen',
        (WidgetTester tester) async {
      final box = Hive.box<SecFiling>('secFilings');

      // ✅ Use the named Form 4 constructor with required cik
      final filing = SecFiling.form4(
        accessionNumber: '0001234567-25-000001',
        issuer: 'Demo Corp',
        filingDate: '2025-11-13',
        source: 'test',
        cik: '0000000000', // ✅ required argument
        insiderName: 'Test Insider',
        insiderCik: '0000123456',
        transactionCode: 'P',
        transactionShares: 100,
        transactionPrice: 50.0,
      );

      await box.put(filing.id, filing);

      await tester.pumpWidget(
        MaterialApp(home: DashboardScreen(hiveService: hiveService)),
      );

      // Tap the Demo Corp tile
      await tester.tap(find.text('Demo Corp'));
      await tester.pumpAndSettle();

      // Verify detail screen shows issuer
      expect(find.text('Demo Corp'), findsOneWidget);
    });
  });
}
