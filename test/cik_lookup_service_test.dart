import 'package:flutter_test/flutter_test.dart';
import 'package:trade_tracker/services/cik_lookup_service.dart';

void main() {
  group('CikLookupService', () {
    test('resolves AAPL to Apple CIK', () async {
      final service = CikLookupService();
      final cik = await service.getCikForTicker('AAPL');

      // Apple’s known CIK is 0000320193
      expect(cik, equals('0000320193'));
    });

    test('returns null for unknown ticker', () async {
      final service = CikLookupService();
      final cik = await service.getCikForTicker('ZZZZZZ'); // nonsense ticker

      expect(cik, isNull);
    });
  });
}
