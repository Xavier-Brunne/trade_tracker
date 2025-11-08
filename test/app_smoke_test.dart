import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/main.dart'; // your root app widget

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

  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    final hiveService = HiveService();

    // Pump your root app widget directly (no extra MaterialApp wrapper)
    await tester.pumpWidget(TradeTrackerApp(hiveService: hiveService));

    // Verify dashboard title appears
    expect(find.text('Dashboard'), findsOneWidget);

    // Verify initial state shows "Add Mock Filing" button
    expect(find.text('Add Mock Filing'), findsOneWidget);
  });
}
