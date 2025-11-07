import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trade_tracker/person.dart';
import 'hive_mock.dart';

void main() {
  late MockBox<Person> mockBox;
  late MockHiveService mockHiveService;

  setUp(() {
    mockBox = MockBox<Person>();
    mockHiveService = MockHiveService(mockBox);

    // Stub basic behavior
    when(() => mockBox.get(any())).thenReturn(null);
    when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
    when(() => mockBox.values).thenReturn([]);
    when(() => mockBox.isOpen).thenReturn(true);
  });

  test('MockHiveService returns mock box', () {
    final box = mockHiveService.getBox<Person>('people');
    expect(box, mockBox);
    expect(box.isOpen, true);
  });

  test('MockHiveService stores and retrieves Person', () async {
    final person = Person(name: 'Alice');
    await mockBox.put('p1', person);

    final retrieved = mockBox.get('p1');
    expect(retrieved?.name, 'Alice');
  });
}
