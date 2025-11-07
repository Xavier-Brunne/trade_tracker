import '../models/sec_filing.dart';

class MockFilingGenerator {
  static int _counter = 1;

  /// Generate a single mock SecFiling
  static SecFiling generate({String issuer = 'Test Corp'}) {
    final filing = SecFiling(
      accessionNumber: 'ACC-${DateTime.now().millisecondsSinceEpoch}',
      filingDate: DateTime.now().toIso8601String(),
      reportDate: DateTime.now().toIso8601String(),
      issuer: issuer,
      isSaved: false, // ✅ default to not saved
      source: 'mock', // ✅ clearly marked as mock
    );

    _counter++;
    return filing;
  }

  /// Generate a batch of mock SecFilings
  static List<SecFiling> generateBatch(int count) {
    return List.generate(
      count,
      (i) => generate(issuer: 'Issuer ${_counter + i}'),
    );
  }
}
