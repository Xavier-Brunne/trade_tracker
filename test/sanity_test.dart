import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/services/hive_service.dart';

/// Example Person model used in tests
class Person {
  final String name;
  Person(this.name);
}

/// FakePerson for fallback registration
class FakePerson extends Fake implements Person {}

/// Mock implementation of HiveService
class MockHiveService extends Mock implements HiveService {}

/// Generic mock implementation of a Hive Box<T>
class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late MockHiveService mockHiveService;
  late MockBox<Person> mockBox;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(FakePerson()); // Person values
    registerFallbackValue(''); // String keys
    registerFallbackValue(MockBox<Person>()); // Box<Person> fallback
  });

  setUp(() {
    mockHiveService = MockHiveService();
    mockBox = MockBox<Person>();
  });

  group('HiveService mocks sanity', () {
    test('MockHiveService and MockBox can be instantiated', () {
      expect(mockHiveService, isA<HiveService>());
      expect(mockBox, isA<Box<Person>>());
    });

    test('HiveService openBox and put/get works with mocks', () async {
      final person = Person('Alice');

      // Stub openBox to return our mockBox
      when(() => mockHiveService.openBox<Person>(any()))
          .thenAnswer((_) async => mockBox);

      // Stub put and get
      when(() => mockBox.put(any(), any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockBox.get(any())).thenReturn(person);

      final box = await mockHiveService.openBox<Person>('people');
      await box.put('key1', person);
      final result = box.get('key1');

      expect(result, isNotNull);
      expect(result!.name, equals('Alice'));
    });
  });
}
