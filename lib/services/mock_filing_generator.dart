import '../models/sec_filing.dart';

class MockFilingGenerator {
  static int _counter = 1;

  static SecFiling generate({String issuer = 'Test Corp'}) {
    final filing = SecFiling(
      accessionNumber: 'ACC-${DateTime.now().millisecondsSinceEpoch}',
      filingDate: DateTime.now().toIso8601String(),
      reportDate: DateTime.now().toIso8601String(),
      issuer: issuer,
      isSaved: false,
      source: 'mock',
      cik: '0000${1000 + _counter}', // fake CIK
      transactionType: _counter % 2 == 0 ? 'Buy' : 'Sell', // alternate Buy/Sell
      rawData: 'Mock filing data for $issuer #$_counter',
    );

    _counter++;
    return filing;
  }

  static List<SecFiling> generateBatch(int count) {
    return List.generate(count, (i) => generate(issuer: 'Issuer ${i + 1}'));
  }
}
