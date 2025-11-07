import 'package:xml/xml.dart' as xml;
import 'package:trade_tracker/models/sec_filing.dart';

class SecForm4RssService {
  static List<SecFiling> parseRss(String rssString) {
    final document = xml.XmlDocument.parse(rssString);
    final items = document.findAllElements('item');

    return items.map((item) {
      final accession = item.findElements('accessionNumber').first.value;
      final issuer = item.findElements('issuer').first.value;
      final filingDate = item.findElements('filingDate').first.value;
      final reportDateStr = item.findElements('pubDate').first.value;

      return SecFiling(
        id: accession ?? '',
        accessionNumber: accession ?? '',
        issuer: issuer ?? '',
        filingDate: filingDate ?? '',
        reportDate: DateTime.tryParse(reportDateStr ?? '') ?? DateTime.now(),
        formType: 'Form 4',
        isSaved: false,
        source: 'rss',
      );
    }).toList();
  }
}
