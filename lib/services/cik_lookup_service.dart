import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple helper to resolve ticker -> CIK using SEC bulk JSON.
class CikLookupService {
  static const _url =
      'https://www.sec.gov/files/company_tickers.json'; // official SEC mapping

  Future<String?> getCikForTicker(String ticker) async {
    final response = await http.get(Uri.parse(_url), headers: {
      'User-Agent': 'trade-tracker/1.0 (darren@example.com)',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      for (final entry in data.values) {
        if ((entry['ticker'] as String).toUpperCase() == ticker.toUpperCase()) {
          // SEC returns CIK as integer, pad to 10 digits
          final cikInt = entry['cik_str'] as int;
          return cikInt.toString().padLeft(10, '0');
        }
      }
    }
    return null;
  }
}
