import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/services/cik_lookup_service.dart';
import 'package:trade_tracker/services/sec_service.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialise Hive in a temp directory
    Hive.init(Directory.systemTemp.path);

    // Register adapters
    Hive.registerAdapter(PersonAdapter());
    Hive.registerAdapter(SecFilingAdapter());

    // Open required boxes
    await Hive.openBox<Person>('people');
    await Hive.openBox<SecFiling>('secFilings');
  });

  tearDownAll(() async {
    await Hive.box<Person>('people').close();
    await Hive.box<SecFiling>('secFilings').close();
  });

  testWidgets('pipeline: ticker -> CIK -> SEC filings -> Hive -> dashboard',
      (WidgetTester tester) async {
    final hiveService = HiveService();
    final cikLookup = CikLookupService();
    final secService = SecService();

    // Resolve ticker to CIK
    final cik = await cikLookup.getCikForTicker('AAPL');
    expect(cik, equals('0000320193'));

    // Fetch filings from SEC
    final filings = await secService.fetchCompanyFilings(cik!);
    expect(filings.isNotEmpty, true);

    // Save filings into Hive
    final box = hiveService.getBox<SecFiling>('secFilings');
    for (final filing in filings.take(2)) {
      await box.put(filing.id, filing);
    }

    // Pump dashboard
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(hiveService: hiveService),
      ),
    );

    // Verify filings appear in dashboard list
    expect(find.byType(ListTile), findsWidgets);
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
