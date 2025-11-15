import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // ✅ for debugPrint
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';

/// Service to fetch SEC Form 4 filings for a given CIK and cache them in Hive.
class SecFilingsService {
  static const _baseUrl = 'https://data.sec.gov/submissions/';
  static const _headers = {
    'User-Agent': 'trade-tracker/1.0 (darren@example.com)', // SEC requires this
    'Accept': 'application/json',
  };

  final HiveService hiveService;

  SecFilingsService({required this.hiveService});

  Future<void> fetchAndCacheFilings(String cik) async {
    // ✅ Correct URL construction: use _baseUrl + 'CIK' + cik
    final url = '${_baseUrl}CIK$cik.json';
    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch filings for CIK $cik (status ${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final recent = data['filings']?['recent'] as Map<String, dynamic>?;

    if (recent == null) {
      debugPrint('DEBUG: No recent filings found for CIK $cik');
      return;
    }

    final forms = recent['form'] as List<dynamic>? ?? [];
    final dates = recent['filingDate'] as List<dynamic>? ?? [];
    final accessions = recent['accessionNumber'] as List<dynamic>? ?? [];
    final descriptions =
        recent['primaryDocDescription'] as List<dynamic>? ?? [];

    final filings = <SecFiling>[];

    for (int i = 0; i < forms.length; i++) {
      if (forms[i] != '4') continue;

      final id = accessions[i].toString();
      final filing = SecFiling(
        id: id,
        issuer: data['name'] ?? 'Unknown',
        formType: forms[i] as String,
        filingDate: dates[i] as String,
        accessionNumber: accessions[i] as String,
        source: 'SEC',
        description: (i < descriptions.length
            ? descriptions[i]
            : 'Form 4 filing') as String,
        isSaved: false,
        cik: cik, // ✅ include CIK so tests can assert filing.cik
      );

      filings.add(filing);
    }

    for (final filing in filings) {
      await hiveService.putFiling(filing);
    }

    debugPrint('DEBUG: Cached ${filings.length} Form 4 filings for CIK $cik');
  }
}
