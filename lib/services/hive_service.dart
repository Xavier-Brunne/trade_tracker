import 'package:hive/hive.dart';

class HiveService {
  /// Opens a Hive box of type T with the given name.
  static Future<Box<T>> openBox<T>(String name) async {
    return await Hive.openBox<T>(name);
  }

  /// Retrieves an already opened Hive box of type T.
  /// Throws if the box is not yet opened.
  static Box<T> getBox<T>(String name) {
    if (!Hive.isBoxOpen(name)) {
      throw Exception("Hive box '$name' is not open. Call openBox first.");
    }
    return Hive.box<T>(name);
  }

  /// Safely checks if a box is open.
  static bool isBoxOpen(String name) {
    return Hive.isBoxOpen(name);
  }

  /// Closes a Hive box if it is open.
  static Future<void> closeBox(String name) async {
    if (Hive.isBoxOpen(name)) {
      await Hive.box(name).close();
    }
  }

  /// Clears all data from a Hive box.
  static Future<void> clearBox(String name) async {
    if (Hive.isBoxOpen(name)) {
      await Hive.box(name).clear();
    }
  }
}
