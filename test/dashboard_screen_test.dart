import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';
import 'package:trade_tracker/services/mock_filing_generator.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'hive_mock.dart';

void main() {
  late MockHiveService mockHiveService;
  late MockBox<SecFiling> mockBox;

  setUpAll(() {
    registerFallbackValue(''); // String keys
    registerFallbackValue(SecFiling(
      id: '',
      issuer: '',
      filingDate: '',
      accessionNumber: '',
      formType: '',
      reportDate: DateTime.now(),
      isSaved: false,
      source: '',
    ));
  });

  setUp(() {
    mockHiveService = MockHiveService();
    mockBox = MockBox<SecFiling>();

    when(() => mockHiveService.getBox<SecFiling>('secFilings'))
        .thenReturn(mockBox);

    when(() => mockBox.values).thenReturn(<SecFiling>[]);
  });

  testWidgets('DashboardScreen renders and adds mock filing',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(hiveService: mockHiveService),
      ),
    );

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Add Mock Filing'), findsOneWidget);

    await tester.tap(find.text('Add Mock Filing'));
    await tester.pump();

    final mock = mockFiling();
    expect(mock.issuer, isNotEmpty);
    expect(mock.formType, equals('Form 4'));
    expect(mock.source, equals('mock'));
  });
}
