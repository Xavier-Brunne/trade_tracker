import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import '../lib/main.dart';
import '../lib/person.dart';
import '../lib/services/hive_service.dart';

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late MockBox<Person> mockBox;

  setUpAll(() {
    mockBox = MockBox<Person>();

    registerFallbackValue(Person(name: 'Fallback'));

    when(() => mockBox.get(any())).thenReturn(null);
    when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
    when(() => mockBox.values).thenReturn([]);
    when(() => mockBox.isOpen).thenReturn(true);

    // ✅ Type-safe override for HiveService.getBox<T>
    HiveService.getBox = <T>(String name) => mockBox as Box<T>;
  });

  testWidgets('Splash screen renders and transitions to dashboard',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Splash screen
    expect(find.text('Trade Tracker'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Dashboard screen
    expect(find.text('Latest SEC Filings'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Tapping SEC card navigates to SEC screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Latest SEC Filings'));
    await tester.pumpAndSettle();

    // SEC screen loaded
    expect(find.byType(FloatingActionButton), findsNWidgets(2));
  });
}
