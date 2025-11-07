import 'package:trade_tracker/models/sec_filing.dart';

/// Generates a mock SecFiling for testing and demo purposes.
SecFiling mockFiling() {
  return SecFiling(
    id: 'mock-id',
    accessionNumber: 'ACC-MOCK',
    issuer: 'Mock Issuer',
    filingDate: '2025-11-07',
    reportDate: DateTime.now(),
    formType: 'Form 4',
    isSaved: false,
    source: 'mock',
  );
}
