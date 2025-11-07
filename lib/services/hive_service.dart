import 'package:hive/hive.dart';

/// Injectable HiveService instead of static methods.
/// This makes testing and mocking much easier.
class HiveService {
  const HiveService();

  /// Open a box by name (creates if not already open).
  Future<Box<T>> openBox<T>(String name) async {
    if (!Hive.isBoxOpen(name)) {
      return await Hive.openBox<T>(name);
    }
    return Hive.box<T>(name);
  }

  /// Get a box by name (assumes it's already open).
  Box<T> getBox<T>(String name) {
    if (!Hive.isBoxOpen(name)) {
      throw Exception("Hive box '$name' is not open. Call openBox first.");
    }
    return Hive.box<T>(name);
  }
}
