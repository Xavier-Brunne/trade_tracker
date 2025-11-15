import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trade_tracker/models/cik_cache_entry.dart';
import 'package:trade_tracker/services/hive_service.dart';

/// Helper to resolve ticker -> CIK using SEC bulk JSON, with caching.
class CikLookupService {
  static const _url = 'https://www.sec.gov/files/company_tickers.json';
  static const _headers = {
    'User-Agent': 'trade-tracker/1.0 (darren@example.com)', // SEC requires this
    'Accept': 'application/json',
  };

  final HiveService hiveService;

  CikLookupService(this.hiveService);

  Future<String?> getCikForTicker(String ticker) async {
    final upper = ticker.toUpperCase();
    final box = hiveService.getBox<CikCacheEntry>('cikCache');

    // 1. Check cache first
    final cached = box.get(upper);
    if (cached != null) {
      return cached.cik;
    }

    // 2. Fetch SEC JSON mapping
    final response = await http.get(Uri.parse(_url), headers: _headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      for (final entry in data.values) {
        final entryTicker = (entry['ticker'] as String).toUpperCase();
        if (entryTicker == upper) {
          final cikStr = (entry['cik_str'] as int).toString().padLeft(10, '0');

          // Save to cache with required cachedAt field
          final cacheEntry = CikCacheEntry(
            ticker: upper,
            cik: cikStr,
            cachedAt: DateTime.now(),
          );
          await box.put(upper, cacheEntry);

          return cikStr;
        }
      }

      return null; // ticker not found
    } else {
      throw Exception(
        'Failed to fetch CIK mapping (status ${response.statusCode})',
      );
    }
  }
}
