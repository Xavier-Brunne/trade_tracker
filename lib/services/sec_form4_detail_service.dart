import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class Form4Detail {
  final Issuer issuer;
  final List<ReportingOwner> owners;
  final List<NonDerivativeTx> transactions;
  final String accessionNumber;
  final DateTime? periodOfReport;

  Form4Detail({
    required this.issuer,
    required this.owners,
    required this.transactions,
    required this.accessionNumber,
    required this.periodOfReport,
  });
}

class Issuer {
  final String name;
  final String cik;

  Issuer({required this.name, required this.cik});
}

class ReportingOwner {
  final String name;
  final String cik;

  ReportingOwner({required this.name, required this.cik});
}

class NonDerivativeTx {
  final String securityTitle;
  final String transactionCode;
  final DateTime date;
  final double? shares;
  final double? pricePerShare;

  NonDerivativeTx({
    required this.securityTitle,
    required this.transactionCode,
    required this.date,
    required this.shares,
    required this.pricePerShare,
  });
}

class SecForm4DetailService {
  Future<Form4Detail> fetchDetail(String xmlUrl) async {
    final res = await http.get(Uri.parse(xmlUrl));
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch Form 4 XML: ${res.statusCode}');
    }

    final doc = XmlDocument.parse(res.body);

    final accessionNumber =
        _firstText(doc.findAllElements('accessionNumber')) ?? '';
    final periodOfReportStr = _firstText(doc.findAllElements('periodOfReport'));
    final periodOfReport =
        periodOfReportStr != null ? DateTime.tryParse(periodOfReportStr) : null;

    final issuerNode = doc.findAllElements('issuer').firstOrNull;
    final issuer = Issuer(
      name: _firstText(issuerNode?.findElements('issuerName')) ?? 'Unknown',
      cik: _firstText(issuerNode?.findElements('issuerCik')) ?? '',
    );

    final owners = doc.findAllElements('reportingOwner').map((o) {
      return ReportingOwner(
        name: _firstText(o.findElements('rptOwnerName')) ?? 'Unknown',
        cik: _firstText(o.findElements('rptOwnerCik')) ?? '',
      );
    }).toList();

    final transactions =
        doc.findAllElements('nonDerivativeTransaction').map((tx) {
      final securityTitle = tx
              .findAllElements('securityTitle')
              .map((e) => e.findElements('value').firstOrNull)
              .whereType<XmlElement>()
              .firstOrNull
              ?.value
              ?.trim() ??
          'Unknown';

      final transactionCode = tx
              .findAllElements('transactionCoding')
              .map((c) => c.findElements('transactionCode').firstOrNull)
              .whereType<XmlElement>()
              .firstOrNull
              ?.value
              ?.trim() ??
          '';

      final dateStr = tx
          .findAllElements('transactionDate')
          .map((d) => d.findElements('value').firstOrNull)
          .whereType<XmlElement>()
          .firstOrNull
          ?.value
          ?.trim();
      final date = dateStr != null
          ? DateTime.tryParse(dateStr) ?? DateTime(1970)
          : DateTime(1970);

      final sharesStr = tx
          .findAllElements('transactionShares')
          .map((s) => s.findElements('value').firstOrNull)
          .whereType<XmlElement>()
          .firstOrNull
          ?.value
          ?.trim();
      final shares = sharesStr != null
          ? double.tryParse(sharesStr.replaceAll(',', ''))
          : null;

      final priceStr = tx
          .findAllElements('transactionPricePerShare')
          .map((p) => p.findElements('value').firstOrNull)
          .whereType<XmlElement>()
          .firstOrNull
          ?.value
          ?.trim();
      final price = priceStr != null
          ? double.tryParse(priceStr.replaceAll(',', ''))
          : null;

      return NonDerivativeTx(
        securityTitle: securityTitle,
        transactionCode: transactionCode,
        date: date,
        shares: shares,
        pricePerShare: price,
      );
    }).toList();

    return Form4Detail(
      issuer: issuer,
      owners: owners,
      transactions: transactions,
      accessionNumber: accessionNumber,
      periodOfReport: periodOfReport,
    );
  }
}

// ----------------- helpers -----------------

extension FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

String? _firstText(Iterable<XmlElement>? nodes) {
  final n = nodes?.firstOrNull;
  final v = n?.value?.trim(); // safe navigation
  return (v == null || v.isEmpty) ? null : v;
}
