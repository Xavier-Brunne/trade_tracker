import 'package:flutter/material.dart';
import '../models/sec_filing.dart';
import '../features/dashboard/dashboard_screen.dart'; // ✅ dashboard import

class FilingDetailScreen extends StatefulWidget {
  final SecFiling filing;

  const FilingDetailScreen({super.key, required this.filing});

  @override
  State<FilingDetailScreen> createState() => _FilingDetailScreenState();
}

class _FilingDetailScreenState extends State<FilingDetailScreen> {
  void _toggleSaved() {
    setState(() {
      widget.filing.isSaved = !widget.filing.isSaved;
      widget.filing.save(); // persist change in Hive
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.filing.isSaved
            ? "✅ Filing marked as saved"
            : "❌ Filing unmarked"),
      ),
    );
  }

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
    final filing = widget.filing;

    return Scaffold(
      appBar: AppBar(
        title: Text(filing.issuer),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Go to Dashboard',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
              );
            },
          ),
        ],
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
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _toggleSaved,
              icon: Icon(
                filing.isSaved ? Icons.bookmark_remove : Icons.bookmark_add,
              ),
              label: Text(
                filing.isSaved ? "Unmark Saved" : "Mark as Saved",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
