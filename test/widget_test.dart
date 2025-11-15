import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_tracker/screens/sec_form4_screen.dart';
import 'package:trade_tracker/services/hive_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecForm4Screen', () {
    testWidgets('renders AppBar and fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: SecForm4Screen(hiveService: HiveService())),
      );

      expect(find.text('New Form 4 Filing'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.text('Save Filing'), findsOneWidget);
    });
  });
}
