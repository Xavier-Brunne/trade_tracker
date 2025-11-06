import 'package:hive/hive.dart';

class HiveService {
  /// Allows test overrides via `HiveService.getBox = (name) => mockBox;`
  static Box<dynamic> Function(String name) getBox = (name) => Hive.box(name);
}
