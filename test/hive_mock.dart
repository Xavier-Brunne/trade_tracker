import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/models/sec_filing.dart';

/// Mock implementation of HiveService for unit and widget tests.
class MockHiveService extends Mock implements HiveService {}

/// Generic mock implementation of a Hive Box<T>.
class MockBox<T> extends Mock implements Box<T> {}

void main() {
  setUpAll(() {
    // Register fallback values for non-nullable arguments
    registerFallbackValue(SecFiling(
      id: 'fallback',
      issuer: 'Fallback Corp',
      filingDate: '2025-01-01',
      accessionNumber: '0000000000',
      formType: 'Form 4',
      reportDate: DateTime.now(),
      isSaved: false,
      source: 'mock',
    ));
    registerFallbackValue(MockBox<SecFiling>());
  });

  group('Sanity checks for mocks', () {
    test('MockHiveService can be instantiated', () {
      final service = MockHiveService();
      expect(service, isA<HiveService>());
    });

    test('MockBox<SecFiling> can be instantiated', () {
      final box = MockBox<SecFiling>();
      expect(box, isA<Box<SecFiling>>());
    });
  });
}
