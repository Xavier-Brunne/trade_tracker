import 'package:flutter/material.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart'; // ✅ add this
import 'package:url_launcher/url_launcher.dart';

class FilingDetailScreen extends StatelessWidget {
  final SecFiling filing;
  final HiveService hiveService; // ✅ new field

  const FilingDetailScreen({
    Key? key,
    required this.filing,
    required this.hiveService,
  }) : super(key: key);

  Future<void> _openDocumentUrl(BuildContext context) async {
    if (filing.documentUrl == null || filing.documentUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No SEC document URL available')),
      );
      return;
    }

    final uri = Uri.parse(filing.documentUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch ${filing.documentUrl}')),
      );
    }
  }

  void _toggleSaved(BuildContext context) {
    final updated = filing.copyWith(isSaved: !filing.isSaved);
    hiveService.putFiling(updated); // ✅ persist change
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated.isSaved
              ? 'Filing saved to bookmarks'
              : 'Filing removed from bookmarks',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filing Detail'),
        actions: [
          IconButton(
            icon: Icon(
              filing.isSaved ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () => _toggleSaved(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Issuer
            Text(
              filing.issuer,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Core filing info
            Text('Form Type: ${filing.formType}'),
            Text('Filing Date: ${filing.filingDate}'),
            Text('Accession #: ${filing.accessionNumber}'),
            Text('Source: ${filing.source}'),

            const Divider(height: 24),

            // Description snippet
            if (filing.description != null && filing.description!.isNotEmpty)
              Text(
                filing.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

            const SizedBox(height: 16),

            // Insider details (Form 4 specific)
            if (filing.insiderName != null)
              Text('Insider: ${filing.insiderName}'),
            if (filing.insiderCik != null)
              Text('Insider CIK: ${filing.insiderCik}'),

            const SizedBox(height: 8),

            // Transaction details
            if (filing.transactionCode != null)
              Text('Transaction Code: ${filing.transactionCode}'),
            if (filing.transactionShares != null)
              Text('Shares: ${filing.transactionShares}'),
            if (filing.transactionPrice != null)
              Text('Price: \$${filing.transactionPrice!.toStringAsFixed(2)}'),

            const SizedBox(height: 16),

            // Document link
            if (filing.documentUrl != null)
              TextButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('View SEC Document'),
                onPressed: () => _openDocumentUrl(context),
              ),
          ],
        ),
      ),
    );
  }
}
