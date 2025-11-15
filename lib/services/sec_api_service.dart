import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/sec_filing.dart';

class SecApiService {
  /// Fetches the most recent Form 4 filings from the SEC RSS feed.
  static Future<List<SecFiling>> fetchRecentForm4Filings() async {
    const url =
        'https://www.sec.gov/cgi-bin/browse-edgar?action=getcurrent&type=4&count=40&output=atom';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load SEC filings');
    }

    final document = XmlDocument.parse(response.body);
    final entries = document.findAllElements('entry');

    return entries.map((entry) {
      final rawTitle = entry.findElements('title').first.value ?? '';
      final link = entry.findElements('link').first.getAttribute('href') ?? '';
      final updated = entry.findElements('updated').first.value ?? '';

      // Extract issuer from title (e.g. "Form 4 filed by Tesla, Inc.")
      String issuer = rawTitle;
      if (rawTitle.toLowerCase().startsWith('form 4 filed by')) {
        issuer = rawTitle
            .replaceFirst(RegExp(r'Form 4 filed by', caseSensitive: false), '')
            .trim();
      }

      // Format filing date to YYYY-MM-DD
      final filingDate =
          updated.contains('T') ? updated.split('T').first : updated;

      final summary = entry.findElements('summary').isNotEmpty
          ? entry.findElements('summary').first.innerText
          : '';

      // Defaults
      String? insiderName;
      String? insiderCik;
      String? transactionCode;
      int? transactionShares;
      double? transactionPrice;
      String? description; // ✅ new field for dashboard snippet

      // Parse summary lines
      for (final line in summary.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.startsWith('Reporting Owner:')) {
          insiderName = trimmed.replaceFirst('Reporting Owner:', '').trim();
        } else if (trimmed.startsWith('Owner CIK:')) {
          insiderCik = trimmed.replaceFirst('Owner CIK:', '').trim();
        } else if (trimmed.startsWith('Transaction Code:')) {
          transactionCode =
              trimmed.replaceFirst('Transaction Code:', '').trim();
        } else if (trimmed.startsWith('Transaction Shares:')) {
          final sharesStr =
              trimmed.replaceFirst('Transaction Shares:', '').trim();
          transactionShares = int.tryParse(sharesStr.replaceAll(',', ''));
        } else if (trimmed.startsWith('Transaction Price:')) {
          final priceStr =
              trimmed.replaceFirst('Transaction Price:', '').trim();
          transactionPrice = double.tryParse(
              priceStr.replaceAll('\$', '').replaceAll(',', ''));
        }
      }

      // ✅ Build a short description snippet
      if (transactionCode != null &&
          transactionShares != null &&
          transactionPrice != null) {
        description =
            '$transactionCode of $transactionShares shares at \$${transactionPrice.toStringAsFixed(2)}';
      } else if (summary.isNotEmpty) {
        description = summary.split('\n').first.trim();
      }

      return SecFiling.form4(
        accessionNumber: link.split('/').last,
        issuer: issuer.isNotEmpty ? issuer : 'Unknown Issuer',
        filingDate: filingDate,
        source: 'sec-live',
        cik: insiderCik ?? '0000000000', // ✅ required argument
        documentUrl: link.isNotEmpty ? link : null,
        insiderName: insiderName,
        insiderCik: insiderCik,
        transactionCode: transactionCode,
        transactionShares: transactionShares,
        transactionPrice: transactionPrice,
        description: description,
      );
    }).toList();
  }
}
