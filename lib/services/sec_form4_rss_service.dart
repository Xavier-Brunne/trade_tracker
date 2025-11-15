// lib/services/sec_form4_rss_service.dart
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:trade_tracker/models/sec_filing.dart';

class SecForm4RssService {
  static const String rssUrl =
      'https://www.sec.gov/cgi-bin/browse-edgar?action=getcurrent&type=4&count=100&output=atom';

  /// Fetches the latest Form 4 filings from the SEC RSS feed.
  static Future<List<SecFiling>> fetchLatestFilings() async {
    final response = await http.get(
      Uri.parse(rssUrl),
      headers: {
        'User-Agent':
            'TradeTrackerApp/1.0 (darren@example.com)', // SEC requires UA
        'Accept-Encoding': 'gzip',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load RSS feed (status ${response.statusCode})');
    }

    return parseRss(response.body);
  }

  /// Parses the SEC RSS XML string into a list of SecFiling objects.
  static List<SecFiling> parseRss(String rssString) {
    final document = xml.XmlDocument.parse(rssString);
    final entries = document.findAllElements('entry');

    return entries.map((entry) {
      final title = entry.getElement('title')?.innerText ?? '';
      final updated = entry.getElement('updated')?.innerText ?? '';
      final summary = entry.getElement('summary')?.innerText ?? '';
      final link = entry.getElement('link')?.getAttribute('href') ?? '';

      // Try to extract a CIK from the summary if present
      String? cik;
      for (final line in summary.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.startsWith('Owner CIK:')) {
          cik = trimmed.replaceFirst('Owner CIK:', '').trim();
          break;
        }
      }

      // Format filing date to YYYY-MM-DD if possible
      final filingDate =
          updated.contains('T') ? updated.split('T').first : updated;

      return SecFiling(
        id: link.isNotEmpty ? link : title,
        accessionNumber: link.isNotEmpty ? link.split('/').last : title,
        issuer: summary.isNotEmpty ? summary : title,
        filingDate: filingDate,
        reportDate: DateTime.tryParse(updated),
        formType: '4', // ✅ standardise to just "4"
        isSaved: false,
        source: 'rss',
        cik: cik ?? '0000000000', // ✅ required argument
        description:
            summary.isNotEmpty ? summary.split('\n').first.trim() : null,
      );
    }).toList();
  }
}
