import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox<T> extends Mock implements Box<T> {}

class HiveMock {
  static void register() {
    final mockBox = MockBox();
    when(() => mockBox.get(any())).thenReturn(null);
    when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
    when(() => mockBox.values).thenReturn([]);
    when(() => mockBox.isOpen).thenReturn(true);

    // Override Hive.box() globally
    Hive.box = <T>(String name) => mockBox as Box<T>;
  }
}
