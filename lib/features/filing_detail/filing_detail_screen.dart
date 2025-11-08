import 'package:flutter/material.dart';
import 'package:trade_tracker/models/sec_filing.dart';

class FilingDetailScreen extends StatelessWidget {
  final SecFiling filing;

  const FilingDetailScreen({Key? key, required this.filing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filing Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(filing.issuer, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Form Type: ${filing.formType}'),
            Text('Filing Date: ${filing.filingDate}'),
            Text('Accession #: ${filing.accessionNumber}'),
            Text('Source: ${filing.source}'),
          ],
        ),
      ),
    );
  }
}
