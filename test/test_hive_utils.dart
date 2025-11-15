import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

/// Initialise Hive in a test environment.
/// Call this in `setUpAll()` for each test file.
/// Example:
///   setUpAll(() async => await initTestHive());
Future<void> initTestHive() async {
  await setUpTestHive(); // resets Hive to a clean in-memory store
}

/// Open a box safely (only if not already open).
Future<Box<T>> openTestBox<T>(String name) async {
  if (Hive.isBoxOpen(name)) {
    return Hive.box<T>(name);
  }
  return await Hive.openBox<T>(name);
}

/// Register an adapter safely (only if not already registered).
void registerAdapterSafely<T>(TypeAdapter<T> adapter) {
  if (!Hive.isAdapterRegistered(adapter.typeId)) {
    Hive.registerAdapter(adapter);
  }
}

/// Dispose Hive after tests.
/// Call this in `tearDownAll()` for each test file.
/// Example:
///   tearDownAll(() async => await disposeTestHive());
Future<void> disposeTestHive() async {
  await tearDownTestHive(); // closes all boxes and resets Hive
}
