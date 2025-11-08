import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/screens/sec_form4_screen.dart';

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

  testWidgets('SecForm4Screen renders basic UI', (WidgetTester tester) async {
    final hiveService = HiveService();

    await tester.pumpWidget(
      MaterialApp(
        home: SecForm4Screen(hiveService: hiveService),
      ),
    );

    // Verify screen title appears (match exactly what your widget renders)
    expect(find.text('Form 4 Filings'), findsOneWidget);

    // Verify basic UI elements exist
    expect(find.byType(TextField), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
