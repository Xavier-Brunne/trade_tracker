import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trade_tracker/features/splash/sec_splash_screen.dart';
import 'hive_mock.dart';

void main() {
  late MockHiveService mockHiveService;

  setUpAll(() {
    // Register fallback values for Hive keys
    registerFallbackValue('');
  });

  setUp(() {
    mockHiveService = MockHiveService();
  });

  testWidgets('SecSplashScreen shows splash and navigates',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SecSplashScreen(hiveService: mockHiveService),
      ),
    );

    expect(find.text('Trade Tracker'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsWidgets);
  });
}
