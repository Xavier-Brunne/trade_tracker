import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trade_tracker/models/sec_filing.dart';

class SecService {
  static const _baseUrl = 'https://data.sec.gov';

  /// Fetch recent filings for a company by CIK (10-digit string).
  Future<List<SecFiling>> fetchCompanyFilings(String cik) async {
    final url = Uri.parse('$_baseUrl/submissions/CIK$cik.json');
    final response = await http.get(url, headers: {
      // SEC requires a User-Agent with contact info
      'User-Agent': 'trade-tracker/1.0 (darren@example.com)',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final filings = data['filings']?['recent'];
      if (filings != null) {
        return List<SecFiling>.generate(
          filings['accessionNumber'].length,
          (i) => SecFiling(
            id: filings['accessionNumber'][i],
            issuer: data['name'] ?? 'Unknown',
            filingDate: filings['filingDate'][i],
            accessionNumber: filings['accessionNumber'][i],
            formType: filings['form'][i],
            // fallback ensures non-null DateTime
            reportDate: DateTime.tryParse(filings['reportDate'][i] ?? '') ??
                DateTime.now(),
            isSaved: false,
            source: 'sec',
          ),
        );
      }
    }
    throw Exception('Failed to load filings');
  }
}
