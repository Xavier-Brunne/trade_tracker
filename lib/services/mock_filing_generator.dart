import 'dart:math';
import 'package:trade_tracker/models/sec_filing.dart';

class MockFilingGenerator {
  static final _rand = Random();

  /// Generates a unique mock SecFiling with randomised values.
  static SecFiling generate() {
    final id = DateTime.now().millisecondsSinceEpoch.toString() +
        _rand.nextInt(9999).toString();

    final accession = '0000${_rand.nextInt(999999)}';
    final cik =
        _rand.nextInt(9999999999).toString().padLeft(10, '0'); // ✅ mock CIK

    return SecFiling(
      id: id,
      issuer: 'TestCorp ${_rand.nextInt(100)}',
      formType: '4',
      filingDate: DateTime.now().toIso8601String().split('T').first,
      accessionNumber: accession,
      source: 'Mock',
      description: 'Sample insider trade filing for testing',
      insiderName: 'John Doe',
      insiderCik: 'CIK${_rand.nextInt(999999)}',
      transactionCode: 'P',
      transactionShares: _rand.nextInt(5000) + 100,
      transactionPrice: (_rand.nextDouble() * 100).roundToDouble(),
      documentUrl:
          'https://www.sec.gov/Archives/edgar/data/${_rand.nextInt(999999)}/mock.html',
      isSaved: false,
      cik: cik, // ✅ required argument
    );
  }
}
