import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

/// Initialise Hive in a test environment.
/// Call this in `setUpAll()` or `setUp()` for each test file.
/// Example:
///   setUpAll(() async => await initTestHive(['people', 'secFilings']));
Future<void> initTestHive(List<String> boxes) async {
  await setUpTestHive();
  for (final name in boxes) {
    if (!Hive.isBoxOpen(name)) {
      await Hive.openBox(name);
    }
  }
}

/// Dispose Hive after tests.
/// Call this in `tearDownAll()` or `tearDown()` for each test file.
Future<void> disposeTestHive() async {
  await tearDownTestHive(); // from hive_test
}
