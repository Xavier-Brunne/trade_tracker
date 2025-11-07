import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_tracker/screens/sec_form4_screen.dart';
import 'hive_mock.dart';

void main() {
  late MockHiveService mockHiveService;

  setUp(() {
    mockHiveService = MockHiveService();
  });

  testWidgets('SecForm4Screen renders AppBar and fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SecForm4Screen(hiveService: mockHiveService),
      ),
    );

    expect(find.text('New Form 4 Filing'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
  });
}
