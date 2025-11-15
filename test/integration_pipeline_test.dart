import 'package:flutter_test/flutter_test.dart';
import 'package:trade_tracker/models/cik_cache_entry.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/cik_lookup_service.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/hive_adapters.dart';

import 'test_hive_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HiveService hiveService;
  late CikLookupService cikService;

  setUpAll(() async {
    await initTestHive();
    registerHiveAdapters();

    await openTestBox<CikCacheEntry>('cikCache');
    await openTestBox<SecFiling>('secFilings');

    hiveService = HiveService();
    cikService = CikLookupService(hiveService);
  });

  tearDownAll(() async {
    await disposeTestHive();
  });

  test('Pipeline integration CIK lookup resolves Apple ticker', () async {
    final cik = await cikService.getCikForTicker('AAPL');
    expect(cik, equals('0000320193'));
  });
}
