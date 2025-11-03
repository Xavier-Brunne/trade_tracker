import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sec_filing.dart';

class SecForm4JsonService {
  static const String baseUrl = 'https://data.sec.gov/submissions/';

  static Future<List<SecFiling>> fetchForm4Filings(String cik) async {
    final url = Uri.parse('$baseUrl' + 'CIK$cik.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final filings = data['filings']['recent'];
      final form4Indexes = List.generate(filings['form'].length, (i) => i)
          .where((i) => filings['form'][i] == '4')
          .toList();

      return form4Indexes.map((i) {
        return SecFiling(
          accessionNumber: filings['accessionNumber'][i],
          filingDate: filings['filingDate'][i],
          reportDate: filings['reportDate'][i],
          issuer: data['name'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load Form 4 filings');
    }
  }
}

