import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:trade_tracker/models/sec_filing.dart';

class SecForm4Service {
  static const String baseUrl = 'https://data.sec.gov/submissions/CIK';
  static const String rssUrl =
      'https://www.sec.gov/cgi-bin/browse-edgar?action=getcurrent&type=4&count=100&output=atom';

  /// Fetch company-specific Form 4 filings via SEC JSON submissions
  static Future<List<SecFiling>> fetchForm4Filings(String cik) async {
    // Ensure CIK is padded to 10 digits
    final paddedCik = cik.padLeft(10, '0');
    final url = Uri.parse('$baseUrl$paddedCik.json');

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'TradeTrackerApp/1.0 (darren@example.com)',
        'Accept-Encoding': 'gzip',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final filings = data['filings']?['recent'] ?? {};

      final accessionNumbers =
          filings['accessionNumber'] as List<dynamic>? ?? [];
      final filingDates = filings['filingDate'] as List<dynamic>? ?? [];
      final reportDates = filings['reportDate'] as List<dynamic>? ?? [];
      final formTypes = filings['form'] as List<dynamic>? ?? [];

      final results = <SecFiling>[];
      for (int i = 0; i < accessionNumbers.length; i++) {
        results.add(SecFiling(
          id: (accessionNumbers[i] ?? '') as String,
          accessionNumber: (accessionNumbers[i] ?? '') as String,
          issuer: (data['name'] ?? '') as String,
          filingDate: (filingDates[i] ?? '') as String,
          reportDate: DateTime.tryParse((reportDates[i] ?? '') as String),
          formType: (formTypes[i] ?? '4') as String,
          isSaved: false,
          source: 'json',
          cik: paddedCik, // ✅ required argument
          description: 'Form 4 filing for $paddedCik',
        ));
      }
      return results;
    } else {
      throw Exception(
          'Failed to load Form 4 filings (status ${response.statusCode})');
    }
  }

  /// Fetch latest Form 4 filings from SEC RSS feed
  static Future<List<SecFiling>> fetchLatestRssFilings() async {
    final response = await http.get(
      Uri.parse(rssUrl),
      headers: {
        'User-Agent': 'TradeTrackerApp/1.0 (darren@example.com)',
        'Accept-Encoding': 'gzip',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load RSS feed (status ${response.statusCode})');
    }

    return parseRss(response.body);
  }

  /// Parse RSS XML into SecFiling objects
  static List<SecFiling> parseRss(String rssString) {
    final document = xml.XmlDocument.parse(rssString);
    final entries = document.findAllElements('entry');

    return entries.map((entry) {
      final accession = entry.findElements('accession-number').isNotEmpty
          ? entry.findElements('accession-number').first.value ?? ''
          : '';
      final issuer = entry.findElements('conformed-name').isNotEmpty
          ? entry.findElements('conformed-name').first.value ?? ''
          : '';
      final filingDate = entry.findElements('filing-date').isNotEmpty
          ? entry.findElements('filing-date').first.value ?? ''
          : '';
      final reportDateStr = entry.findElements('updated').isNotEmpty
          ? entry.findElements('updated').first.value ?? ''
          : '';

      // Try to extract CIK if present in RSS entry
      String? cik;
      final cikElement = entry.findElements('cik').isNotEmpty
          ? entry.findElements('cik').first.value
          : null;
      cik = cikElement?.trim();

      return SecFiling(
        id: accession,
        accessionNumber: accession,
        issuer: issuer,
        filingDate: filingDate,
        reportDate: DateTime.tryParse(reportDateStr),
        formType: '4',
        isSaved: false,
        source: 'rss',
        cik: cik ?? '0000000000', // ✅ required argument
        description: 'RSS Form 4 filing',
      );
    }).toList();
  }
}
