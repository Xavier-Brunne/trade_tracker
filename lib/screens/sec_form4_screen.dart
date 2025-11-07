import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/sec_filing.dart';
import '../services/sec_form4_json_service.dart';
import '../services/sec_form4_rss_service.dart';
import '../services/mock_filing_generator.dart'; // ✅ add this
import '../screens/filing_detail_screen.dart';

class SecForm4Screen extends StatefulWidget {
  const SecForm4Screen({super.key});

  @override
  State<SecForm4Screen> createState() => _SecForm4ScreenState();
}

class _SecForm4ScreenState extends State<SecForm4Screen> {
  late Box<SecFiling> filingsBox;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    filingsBox = Hive.box<SecFiling>('secFilings');
    _autoFetchRss();
  }

  Future<void> _autoFetchRss() async {
    setState(() => isLoading = true);
    try {
      final rssFilings = await SecForm4RssService.fetchRecentFilings();
      for (final filing in rssFilings) {
        filingsBox.add(filing);
      }
    } catch (e) {
      debugPrint("RSS fetch error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchJsonFilings() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear existing filings?"),
        content: const Text(
            "Do you want to clear old filings before fetching new ones?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes")),
        ],
      ),
    );

    setState(() => isLoading = true);

    try {
      const testCik = '0000320193'; // Apple Inc.
      final newFilings = await SecForm4JsonService.fetchForm4Filings(testCik);

      if (shouldClear == true) {
        await filingsBox.clear();
      }

      for (final filing in newFilings) {
        filingsBox.add(filing);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("JSON filings fetched and saved")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchByCik(String? cik) async {
    if (cik == null || cik.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Missing CIK")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final newFilings = await SecForm4JsonService.fetchForm4Filings(cik);
      for (final filing in newFilings) {
        filingsBox.add(filing);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fetched filings for CIK $cik")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching CIK $cik: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _openFilingDetail(SecFiling filing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilingDetailScreen(filing: filing),
      ),
    );
  }

  Widget sourceBadge(String source) {
    final isJson = source == 'json';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isJson ? Colors.blue[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isJson ? Icons.data_object : Icons.rss_feed, size: 14),
          const SizedBox(width: 4),
          Text(
            isJson ? 'JSON' : 'RSS',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFilingTile(SecFiling filing) {
    return ListTile(
      leading: const Icon(Icons.article_outlined),
      title: Text(filing.issuer), // ✅ use issuer field
      subtitle: Text('Filed on ${filing.filingDate}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          sourceBadge(filing.source),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.cloud_download),
            tooltip: 'Fetch by CIK',
            onPressed: () => _fetchByCik(filing.cik),
          ),
        ],
      ),
      onTap: () => _openFilingDetail(filing),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEC Form 4 Filings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Fetch JSON Filings',
            onPressed: _fetchJsonFilings,
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Add Mock Filing',
            onPressed: () {
              final mock = MockFilingGenerator.generate();
              filingsBox.add(mock);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Added one mock filing")),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder(
              valueListenable: filingsBox.listenable(),
              builder: (context, Box<SecFiling> box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text('No filings available.'));
                }
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final filing = box.getAt(index);
                    if (filing == null) return const SizedBox.shrink();
                    return _buildFilingTile(filing);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _autoFetchRss,
        icon: const Icon(Icons.rss_feed),
        label: const Text("Fetch RSS"),
      ),
    );
  }
}
