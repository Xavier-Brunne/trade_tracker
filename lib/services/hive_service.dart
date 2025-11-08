import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class HiveService {
  final Map<String, Box> _boxes = {};

  /// Opens a Hive box and caches it. Safe to call multiple times.
  Future<Box<T>> openBox<T>(String name) async {
    if (_boxes.containsKey(name)) return _boxes[name] as Box<T>;

    // Dev-mode reset: wipe box before opening
    if (kDebugMode && Hive.isBoxOpen(name)) {
      await Hive.box(name).close();
      await Hive.deleteBoxFromDisk(name);
    }

    final box = await Hive.openBox<T>(name);
    _boxes[name] = box;
    return box;
  }

  /// Returns a cached box. Throws if not opened.
  Box<T> getBox<T>(String name) {
    final box = _boxes[name];
    if (box == null) {
      throw HiveError('Box "$name" not opened. Call openBox<T>() first.');
    }
    return box as Box<T>;
  }

  /// Optional: seed mock data for dev dashboard preview
  Future<void> seedBox<T>(String name, Map<dynamic, T> entries) async {
    final box = getBox<T>(name);
    if (box.isEmpty && kDebugMode) {
      await box.putAll(entries);
    }
  }

  /// Optional: clear all boxes (dev only)
  Future<void> resetAllBoxes() async {
    for (final name in _boxes.keys) {
      await Hive.deleteBoxFromDisk(name);
    }
    _boxes.clear();
  }
}
