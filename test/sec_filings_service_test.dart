import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/services/sec_filings_service.dart';
import 'package:trade_tracker/hive_adapters.dart';

void main() {
  late HiveService hiveService;
  late SecFilingsService filingsService;

  setUp(() async {
    // Initialise in-memory Hive
    await setUpTestHive();

    // Register adapters (critical for SecFiling!)
    registerHiveAdapters();

    // Open the secFilings box
    hiveService = HiveService();
    await hiveService.openBox<SecFiling>('secFilings');

    filingsService = SecFilingsService(hiveService: hiveService);
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('fetchAndCacheFilings caches Form 4 filings for Apple Inc.', () async {
    // Apple Inc. CIK: 0000320193
    const cik = '0000320193';

    await filingsService.fetchAndCacheFilings(cik);

    final box = hiveService.getBox<SecFiling>('secFilings');
    expect(box.isNotEmpty, true, reason: 'Box should contain filings');

    final filing = box.values.first;
    expect(filing.formType, equals('4'));
    expect(filing.source, equals('SEC'));
    expect(filing.cik, equals(cik));
    print('Fetched ${box.length} Form 4 filings for CIK $cik');
  });

  test('fetchAndCacheFilings throws for invalid CIK', () async {
    const invalidCik = '9999999999';

    expect(
      () async => filingsService.fetchAndCacheFilings(invalidCik),
      throwsException,
      reason: 'Invalid CIK should throw an exception',
    );
  });
}
