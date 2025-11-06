import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/sec_filing.dart';

class SecForm4RssService {
  static const String rssUrl =
      'https://www.sec.gov/Archives/edgar/usgaap.rss.xml';

  static Future<List<SecFiling>> fetchRecentFilings() async {
    final response = await http.get(Uri.parse(rssUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load RSS feed');
    }

    final document = XmlDocument.parse(response.body);
    final items = document.findAllElements('item');

    return items.map((item) {
      final title = item.getElement('title')?.text ?? '';
      final pubDate = item.getElement('pubDate')?.text ?? '';
      final link = item.getElement('link')?.text ?? '';
      final accessionMatch =
          RegExp(r'accession-number=(\d{10}-\d{2}-\d{6})').firstMatch(link);
      final accessionNumber = accessionMatch?.group(1) ?? 'unknown';

      return SecFiling(
        accessionNumber: accessionNumber,
        filingDate: pubDate,
        reportDate: pubDate,
        issuer: title,
        isSaved: false,
      );
    }).toList();
  }
}
