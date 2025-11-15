import 'package:flutter/material.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart'; // ✅ for saving/removing filings
import 'package:url_launcher/url_launcher.dart'; // ✅ for opening links
import 'package:flutter/services.dart'; // ✅ for clipboard
import 'package:share_plus/share_plus.dart'; // ✅ for sharing

class FilingDetailScreen extends StatelessWidget {
  final SecFiling filing;
  final HiveService hiveService; // ✅ added

  const FilingDetailScreen({
    Key? key,
    required this.filing,
    required this.hiveService, // ✅ added
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

  Future<void> _copyDocumentUrl(BuildContext context) async {
    if (filing.documentUrl == null || filing.documentUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No SEC document URL available')),
      );
      return;
    }

    await Clipboard.setData(ClipboardData(text: filing.documentUrl!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SEC document URL copied to clipboard')),
    );
  }

  Future<void> _shareDocumentUrl(BuildContext context) async {
    if (filing.documentUrl == null || filing.documentUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No SEC document URL available')),
      );
      return;
    }

    await Share.share(
      'Check out this SEC filing for ${filing.issuer} (${filing.formType})\n${filing.documentUrl!}',
      subject: 'SEC Filing: ${filing.issuer}',
    );
  }

  void _toggleSaved(BuildContext context) async {
    final updated = filing.copyWith(isSaved: !filing.isSaved);
    await hiveService.putFiling(updated); // ✅ persist change
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

            // Document actions
            if (filing.documentUrl != null)
              Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('View'),
                    onPressed: () => _openDocumentUrl(context),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                    onPressed: () => _copyDocumentUrl(context),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    onPressed: () => _shareDocumentUrl(context),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
