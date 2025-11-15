import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trade_tracker/models/sec_filing.dart';

class SecForm4JsonService {
  static const String baseUrl = 'https://data.sec.gov/submissions/';

  /// Fetches Form 4 filings for a given CIK
  static Future<List<SecFiling>> fetchForm4Filings(String cik) async {
    final url = Uri.parse('$baseUrl$cik.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final filings = data['filings']['recent'];
      final form4Indexes = List.generate(filings['form'].length, (i) => i)
          .where((i) => filings['form'][i] == '4')
          .toList();

      return form4Indexes.map((i) {
        final accession = filings['accessionNumber'][i];
        final formType = filings['form'][i];
        final filingDate = filings['filingDate'][i];
        final reportDate = filings['reportDate'][i];

        return SecFiling(
          id: accession,
          accessionNumber: accession,
          issuer: data['name'] ?? 'Unknown Issuer',
          filingDate: filingDate,
          reportDate: reportDate != null && reportDate.isNotEmpty
              ? DateTime.tryParse(reportDate)
              : null,
          formType: formType,
          isSaved: false,
          source: 'json',
          cik: cik, // ✅ required argument passed through
          description: 'Form 4 filing for $cik', // optional snippet
        );
      }).toList();
    } else {
      throw Exception('Failed to load Form 4 filings');
    }
  }
}
