import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trade_tracker/features/splash/sec_splash_screen.dart';
import 'hive_mock.dart';

void main() {
  late MockBox<dynamic> mockBox;
  late MockHiveService mockHiveService;

  setUp(() {
    mockBox = MockBox<dynamic>();
    mockHiveService = MockHiveService(mockBox);

    when(() => mockBox.isOpen).thenReturn(true);
  });

  testWidgets('SecSplashScreen navigates to Dashboard with hiveService',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SecSplashScreen(hiveService: mockHiveService),
    ));

    // Tap the Continue button
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Verify DashboardScreen is shown
    expect(find.text('Trade Tracker Dashboard'), findsOneWidget);
  });
}
