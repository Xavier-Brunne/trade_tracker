import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/services/hive_service.dart';

// Example Person model used in tests
class Person {
  final String name;
  Person(this.name);
}

// FakePerson for fallback registration
class FakePerson extends Fake implements Person {}

class MockHiveService extends Mock implements HiveService {}

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late MockHiveService mockHiveService;
  late MockBox<Person> mockBox;

  setUpAll(() {
    registerFallbackValue(FakePerson()); // ✅ Person values
    registerFallbackValue(''); // ✅ String keys
  });

  setUp(() {
    mockHiveService = MockHiveService();
    mockBox = MockBox<Person>();
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

    expect(result!.name, equals('Alice'));
  });
}
