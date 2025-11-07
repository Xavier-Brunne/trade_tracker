import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'hive_mock.dart';

void main() {
  late MockBox<SecFiling> mockBox;
  late MockHiveService mockHiveService;

  setUp(() {
    mockBox = MockBox<SecFiling>();
    mockHiveService = MockHiveService(mockBox);

    when(() => mockBox.listenable()).thenReturn(ValueNotifier([]));
    when(() => mockBox.isEmpty).thenReturn(true);
    when(() => mockBox.length).thenReturn(0);
  });

  testWidgets('Dashboard loads with mock HiveService', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: DashboardScreen(hiveService: mockHiveService),
    ));

    expect(find.text('Trade Tracker Dashboard'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
