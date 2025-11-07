import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/screens/filing_detail_screen.dart';
import 'hive_mock.dart';

void main() {
  late MockBox<SecFiling> mockBox;
  late MockHiveService mockHiveService;
  late SecFiling filing;

  setUp(() {
    mockBox = MockBox<SecFiling>();
    mockHiveService = MockHiveService(mockBox);

    filing = SecFiling(
      id: '123',
      issuer: 'TestCo',
      filingDate: '2025-11-07',
      formType: '4',
    );

    when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
    when(() => mockBox.isOpen).thenReturn(true);
  });

  testWidgets('FilingDetailScreen saves filing with mock HiveService',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: FilingDetailScreen(filing: filing, hiveService: mockHiveService),
    ));

    await tester.tap(find.text('Save Filing'));
    await tester.pump();

    verify(() => mockBox.put('123', filing)).called(1);
    expect(find.text('✅ Filing saved'), findsOneWidget);
  });
}
