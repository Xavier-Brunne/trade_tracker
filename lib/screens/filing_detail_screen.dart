import 'package:flutter/material.dart';
import '../models/sec_filing.dart';
import '../services/hive_service.dart';

class FilingDetailScreen extends StatelessWidget {
  final SecFiling filing;
  final HiveService hiveService;

  const FilingDetailScreen({
    super.key,
    required this.filing,
    required this.hiveService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filing Detail: ${filing.issuer}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Issuer: ${filing.issuer}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Date: ${filing.filingDate}'),
            const SizedBox(height: 8),
            Text('Form Type: ${filing.formType}'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Filing'),
              onPressed: () async {
                final box = hiveService.getBox<SecFiling>('secFilings');
                await box.put(filing.id, filing);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Filing saved")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
