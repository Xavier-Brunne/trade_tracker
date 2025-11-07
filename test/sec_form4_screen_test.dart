import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trade_tracker/screens/sec_form4_screen.dart';
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

  testWidgets('SecForm4Screen renders basic UI', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SecForm4Screen(hiveService: mockHiveService),
      ),
    );

    expect(find.text('Form 4 Filings'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
