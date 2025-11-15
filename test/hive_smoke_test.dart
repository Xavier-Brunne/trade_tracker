import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/hive_adapters.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Hive smoke test', () {
    setUpAll(() async {
      await Hive.initFlutter();
      registerHiveAdapters();
      await Hive.openBox<SecFiling>('secFilings');
    });

    test('write and read SecFiling', () async {
      final box = Hive.box<SecFiling>('secFilings');

      final filing = SecFiling(
        id: 'test1',
        issuer: 'Test Corp',
        formType: '4',
        filingDate: '2025-11-14',
        accessionNumber: '0000000001',
        source: 'Mock',
        description: 'Sample insider trade filing',
        cik: '0000000000', // ✅ required argument
      );

      await box.put(filing.id, filing);

      final readBack = box.get('test1');
      expect(readBack, isNotNull);
      expect(readBack!.issuer, 'Test Corp');
    });
  });
}
