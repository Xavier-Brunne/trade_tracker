import 'package:flutter_test/flutter_test.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/models/settings.dart';
import 'package:trade_tracker/models/cik_cache_entry.dart';
import 'package:trade_tracker/models/trade.dart';
import 'package:trade_tracker/models/portfolio.dart';
import 'package:trade_tracker/models/user_prefs.dart';
import 'package:trade_tracker/services/cik_lookup_service.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/hive_adapters.dart';

import 'test_hive_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HiveService hiveService;
  late CikLookupService cikService;

  setUpAll(() async {
    // Initialise Hive test environment
    await initTestHive();

    // Register all adapters centrally
    registerHiveAdapters();

    // Open all relevant boxes
    await openTestBox<Person>('people');
    await openTestBox<SecFiling>('secFilings');
    await openTestBox<Settings>('settings');
    await openTestBox<CikCacheEntry>('cikCache'); // ✅ required for CIK lookups
    await openTestBox<Trade>('trades');
    await openTestBox<Portfolio>('portfolios');
    await openTestBox<UserPrefs>('userPrefs');

    // Initialise services with HiveService
    hiveService = HiveService();
    cikService = CikLookupService(hiveService);
  });

  tearDownAll(() async {
    // Dispose Hive test environment
    await disposeTestHive();
  });

  group('CIKLookupService', () {
    test('resolves Apple ticker to correct CIK', () async {
      final cik = await cikService.getCikForTicker('AAPL');
      expect(cik, equals('0000320193'));
    });

    test('resolves Microsoft ticker to correct CIK', () async {
      final cik = await cikService.getCikForTicker('MSFT');
      expect(cik, equals('0000789019'));
    });
  });
}
