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

    // ✅ Type-safe override for generic HiveService.getBox<T>
    HiveService.getBox = <T>(String name) => mockBox as Box<T>;
  });

  testWidgets('App boots and dashboard loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Splash screen
    expect(find.text('Trade Tracker'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for splash transition
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Dashboard screen
    expect(find.text('Latest SEC Filings'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
