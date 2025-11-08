import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialise Hive in a temp directory (no path_provider plugin needed)
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

  group('DashboardScreen', () {
    testWidgets('renders and adds mock filing', (WidgetTester tester) async {
      final hiveService = HiveService();

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(hiveService: hiveService),
        ),
      );

      // Verify dashboard title
      expect(find.text('Dashboard'), findsOneWidget);

      // Initially empty, shows "Add Mock Filing" button
      expect(find.text('Add Mock Filing'), findsOneWidget);

      // Tap button to add mock filing
      await tester.tap(find.text('Add Mock Filing'));
      await tester.pumpAndSettle();

      // Verify a filing appears in the list
      expect(find.byType(ListTile), findsWidgets);
    });
  });
}
