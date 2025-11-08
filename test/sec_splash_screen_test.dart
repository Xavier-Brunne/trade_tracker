import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/features/splash/sec_splash_screen.dart';

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

  testWidgets('SecSplashScreen shows splash and navigates',
      (WidgetTester tester) async {
    final hiveService = HiveService();

    await tester.pumpWidget(
      MaterialApp(
        home: SecSplashScreen(hiveService: hiveService),
      ),
    );

    // Verify splash text appears (match exactly what your widget renders)
    expect(find.text('Trade Tracker'), findsOneWidget);

    // Pump enough frames to allow navigation
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify dashboard title appears after navigation
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
