import 'dart:typed_data';
import 'package:hive/hive.dart';

/// A lightweight in-memory mock of HiveService for testing.
/// Mirrors the real HiveService API so you can swap it in tests.
class MockHiveService {
  final Map<String, Box> _boxes = {};

  /// Opens a "box" by name. In tests this just creates an in-memory Box.
  Future<Box<T>> openBox<T>(String name) async {
    if (_boxes.containsKey(name)) return _boxes[name] as Box<T>;

    // Use Hive's in-memory box (no disk I/O)
    final box = await Hive.openBox<T>(
      name,
      bytes: Uint8List.fromList([]), // ✅ correct type
    );
    _boxes[name] = box;
    return box;
  }

  /// Returns a cached box. Throws if not opened.
  Box<T> getBox<T>(String name) {
    final box = _boxes[name];
    if (box == null) {
      throw HiveError('Mock box "$name" not opened. Call openBox<T>() first.');
    }
    return box as Box<T>;
  }

  /// Seeds mock data into a box for test setup.
  Future<void> seedBox<T>(String name, Map<dynamic, T> entries) async {
    final box = getBox<T>(name);
    await box.putAll(entries);
  }

  /// Clears all boxes (useful between tests).
  Future<void> resetAllBoxes() async {
    for (final box in _boxes.values) {
      await box.clear();
      await box.close();
    }
    _boxes.clear();
  }
}
