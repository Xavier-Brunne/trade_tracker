import 'package:hive/hive.dart';

part 'cik_cache_entry.g.dart';

@HiveType(typeId: 3) // ✅ unique typeId
class CikCacheEntry {
  @HiveField(0)
  final String ticker;

  @HiveField(1)
  final String cik;

  @HiveField(2)
  final DateTime cachedAt;

  CikCacheEntry({
    required this.ticker,
    required this.cik,
    required this.cachedAt,
  });
}
