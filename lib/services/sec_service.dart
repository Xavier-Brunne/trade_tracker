import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trade_tracker/models/sec_filing.dart';

class SecService {
  static const _baseUrl = 'https://data.sec.gov/submissions/';
  static const _headers = {
    'User-Agent': 'trade-tracker/1.0 (darren@example.com)',
    'Accept': 'application/json',
  };

  /// Fetch recent filings for a company by CIK (10-digit string).
  Future<List<SecFiling>> fetchCompanyFilings(String cik) async {
    final url = Uri.parse('$_baseUrl${cik}.json');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final filings = data['filings']?['recent'];
      if (filings != null) {
        return List<SecFiling>.generate(
          filings['accessionNumber'].length,
          (i) => SecFiling(
            id: filings['accessionNumber'][i],
            accessionNumber: filings['accessionNumber'][i],
            issuer: data['name'] ?? 'Unknown',
            filingDate: filings['filingDate'][i],
            formType: filings['form'][i],
            reportDate: DateTime.tryParse(filings['reportDate'][i] ?? ''),
            isSaved: false,
            source: 'sec.gov',
            cik: cik, // ✅ required argument
            description: 'Filing ${filings['form'][i]} for $cik',
          ),
        );
      }
    }
    throw Exception(
        'Failed to load filings (status ${response.statusCode}) for CIK $cik');
  }
}
