import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_tracker/screens/sec_form4_screen.dart';
import 'package:trade_tracker/services/hive_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecForm4Screen', () {
    testWidgets('renders AppBar, fields, and save button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: SecForm4Screen(hiveService: HiveService())),
      );

      // Match production widget
      expect(find.text('New Form 4 Filing'), findsOneWidget);

      // Expect 4 TextFormFields (Issuer, Accession Number, Shares, Price)
      expect(find.byType(TextFormField), findsNWidgets(4));

      // Expect Save Filing button
      expect(find.text('Save Filing'), findsOneWidget);
    });
  });
}
