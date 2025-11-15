import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/services/mock_filing_generator.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/models/person.dart';

void main() {
  late HiveService hiveService;

  setUpAll(() async {
    await setUpTestHive();
    Hive.registerAdapter(SecFilingAdapter());
    Hive.registerAdapter(PersonAdapter());
    await Hive.openBox<SecFiling>('secFilings');
    await Hive.openBox<Person>('people');
    await Hive.openBox('settings');
    hiveService = HiveService();
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });

  testWidgets('Dashboard shows filings and navigates to detail screen',
      (WidgetTester tester) async {
    // Insert a mock filing into Hive
    final mock = MockFilingGenerator.generate();
    await hiveService.getBox<SecFiling>('secFilings').put(mock.id, mock);

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(hiveService: hiveService),
      ),
    );

    // Verify the mock filing appears in the list
    expect(find.text(mock.issuer), findsOneWidget);

    // Tap the list tile
    await tester.tap(find.text(mock.issuer));
    await tester.pumpAndSettle();

    // Verify detail screen renders
    expect(find.text('Accession: ${mock.accessionNumber}'), findsOneWidget);
  });
}
