import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SecFilingAdapter());

  group('FilingsListScreen', () {
    late HiveService hiveService;
    late Box<SecFiling> filingsBox;

    setUp(() async {
      hiveService = HiveService();
      filingsBox = await Hive.openBox<SecFiling>('secFilings');
      await filingsBox.clear();

      // Seed multiple filings
      await filingsBox.put(
        '1',
        SecFiling(
          id: '1',
          issuer: 'Demo Corp',
          filingDate: '2025-11-08',
          accessionNumber: '0000000001',
          formType: 'Form 4',
          reportDate: DateTime.now(),
          isSaved: true,
          source: 'mock',
        ),
      );
      await filingsBox.put(
        '2',
        SecFiling(
          id: '2',
          issuer: 'Test Inc',
          filingDate: '2025-11-07',
          accessionNumber: '0000000002',
          formType: '10-K',
          reportDate: DateTime.now(),
          isSaved: false,
          source: 'mock',
        ),
      );
    });

    testWidgets('renders multiple filings in list',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(hiveService: hiveService),
        ),
      );

      // Verify both seeded filings appear
      expect(find.text('Demo Corp'), findsOneWidget);
      expect(find.text('Form 4 • 2025-11-08'), findsOneWidget);

      expect(find.text('Test Inc'), findsOneWidget);
      expect(find.text('10-K • 2025-11-07'), findsOneWidget);
    });
  });
}
