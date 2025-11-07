import 'package:hive/hive.dart';

class HiveService {
  /// Allows test overrides via `HiveService.getBox = <T>(name) => mockBox;`
  static Box<T> Function<T>(String name) getBox = <T>(String name) {
    if (!Hive.isBoxOpen(name)) {
      throw HiveError('Box "$name" must be opened before accessing.');
    }

    final box = Hive.box<T>(name);
    print('📦 HiveService accessed box "$name" as ${box.runtimeType}');
    return box;
  };
}
