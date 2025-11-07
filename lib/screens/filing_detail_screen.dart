import 'package:flutter/material.dart';
import '../models/sec_filing.dart';

class FilingDetailScreen extends StatelessWidget {
  final SecFiling filing;

  const FilingDetailScreen({super.key, required this.filing});

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filing.issuer),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _detailRow('Accession Number', filing.accessionNumber),
            _detailRow('Filing Date', filing.filingDate),
            _detailRow('Report Date', filing.reportDate),
            _detailRow('Issuer', filing.issuer),
            _detailRow('Source', filing.source),
            _detailRow('Saved', filing.isSaved ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }
}
