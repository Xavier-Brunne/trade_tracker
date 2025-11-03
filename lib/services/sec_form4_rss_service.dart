
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class SecForm4Filing {
  final String companyName;
  final String filingDate;
  final String link;

  SecForm4Filing({
    required this.companyName,
    required this.filingDate,
    required this.link,
  });
}

class SecForm4RssService {
  static const String _rssUrl =
      'https://www.sec.gov/cgi-bin/browse-edgar?action=getcurrent&type=4&count=100&output=atom';

  Future<List<SecForm4Filing>> fetchForm4Filings() async {
    final response = await http.get(Uri.parse(_rssUrl));

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      final entries = document.findAllElements('entry');

      return entries.map((entry) {
        final title = entry.findElements('title').single.text;
        final updated = entry.findElements('updated').single.text;
        final link = entry.findElements('link').single.getAttribute('href') ?? '';

        return SecForm4Filing(
          companyName: title,
          filingDate: updated,
          link: link,
        );
      }).toList();
    } else {
      throw Exception('Failed to load SEC Form 4 filings');
    }
  }
}

