import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';
import 'package:trade_tracker/services/mock_filing_generator.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'hive_mock.dart'; // defines MockHiveService + MockBox<T>

void main() {
  late MockHiveService mockHiveService;
  late MockBox<SecFiling> mockBox;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue('demoKey');
    registerFallbackValue(SecFiling(
      id: 'demo',
      issuer: 'Demo Corp',
      filingDate: '2025-11-08',
      accessionNumber: '0000000001',
      formType: 'Form 4',
      reportDate: DateTime.now(),
      isSaved: false,
      source: 'mock',
    ));
  });

  setUp(() {
    mockHiveService = MockHiveService();
    mockBox = MockBox<SecFiling>();

    // Stub HiveService.getBox to return our mock box
    when(() => mockHiveService.getBox<SecFiling>('secFilings'))
        .thenReturn(mockBox);

    // Stub box.values to start empty
    when(() => mockBox.values).thenReturn(<SecFiling>[]);
  });

  testWidgets('DashboardScreen renders and adds mock filing',
      (WidgetTester tester) async {
    // Pump the dashboard with the mocked HiveService
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(hiveService: mockHiveService),
      ),
    );

    // Verify initial UI
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Add Mock Filing'), findsOneWidget);

    // Tap the "Add Mock Filing" button
    await tester.tap(find.text('Add Mock Filing'));
    await tester.pump();

    // Generate a mock filing and assert its fields
    final mock = mockFiling();
    expect(mock.issuer, isNotEmpty);
    expect(mock.formType, equals('Form 4'));
    expect(mock.source, equals('mock'));

    // Optionally, verify the box now contains the mock filing
    when(() => mockBox.values).thenReturn([mock]);
    expect(mockBox.values.length, 1);
    expect(mockBox.values.first.issuer, 'Demo Corp');
  });
}
