import 'package:hive/hive.dart';

class CikCacheService {
  static const _boxName = 'cikCache';

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<String>(_boxName);
    }
  }

  Box<String> get _box => Hive.box<String>(_boxName);

  /// Save a ticker → CIK mapping
  Future<void> saveCik(String ticker, String cik) async {
    await _box.put(ticker.toUpperCase(), cik);
  }

  /// Retrieve cached CIK for a ticker
  String? getCik(String ticker) {
    return _box.get(ticker.toUpperCase());
  }

  /// Check if ticker is cached
  bool hasCik(String ticker) {
    return _box.containsKey(ticker.toUpperCase());
  }
}
