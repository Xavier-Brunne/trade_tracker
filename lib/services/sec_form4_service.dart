import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trade_tracker/models/sec_filing.dart';

class SecForm4Service {
  static const String baseUrl = 'https://api.sec.gov/form4/';

  static Future<List<SecFiling>> fetchForm4Filings(String cik) async {
    final url = Uri.parse('$baseUrl$cik');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;

      return data.map((entry) {
        final accession = entry['accessionNumber'] ?? '';
        final issuer = entry['issuer'] ?? '';
        final filingDate = entry['filingDate'] ?? '';
        final reportDateStr = entry['reportDate'] ?? '';

        return SecFiling(
          id: accession,
          accessionNumber: accession,
          issuer: issuer,
          filingDate: filingDate,
          reportDate: DateTime.tryParse(reportDateStr) ?? DateTime.now(),
          formType: entry['formType'] ?? 'Form 4',
          isSaved: false,
          source: 'api',
        );
      }).toList();
    } else {
      throw Exception('Failed to load Form 4 filings');
    }
  }
}
