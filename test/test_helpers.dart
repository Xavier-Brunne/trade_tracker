import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

/// Call this in setUp() for each test file.
/// Example:
///   setUp(() async => await initTestHive(['people']));
Future<void> initTestHive(List<String> boxes) async {
  await setUpTestHive();
  for (final name in boxes) {
    if (!Hive.isBoxOpen(name)) {
      await Hive.openBox(name);
    }
  }
}

/// Call this in tearDown() for each test file.
Future<void> disposeTestHive() async {
  await tearDownTestHive(); // from hive_test
}
