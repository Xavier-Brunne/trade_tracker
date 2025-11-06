import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/sec_filing.dart';
import '../services/sec_form4_json_service.dart';
import '../services/sec_form4_rss_service.dart';

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

  @override
  Widget build(BuildContext context) {
    final filings = filingsBox.values.toList()
      ..sort((a, b) => b.filingDate.compareTo(a.filingDate));

    return Scaffold(
      appBar: AppBar(title: const Text('Latest SEC Filings')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filings.isEmpty
              ? const Center(
                  child: Text(
                    "No filings available.\nTap a button below to fetch data.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: filings.length,
                  itemBuilder: (context, index) {
                    final filing = filings[index];
                    final isHighInterest = filing.isSaved;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: isHighInterest
                          ? Colors.green[100]
                          : Colors.yellow[100],
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, right: 8),
                            child: ListTile(
                              title: Text(filing.issuer,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  "Filed: ${filing.filingDate} • Reported: ${filing.reportDate}"),
                              trailing: Text(filing.accessionNumber),
                              onTap: () {
                                // TODO: Navigate to filing details
                              },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: sourceBadge(filing.source),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'json',
            icon: const Icon(Icons.download),
            label: const Text("Fetch by CIK"),
            onPressed: _fetchJsonFilings,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'rss',
            icon: const Icon(Icons.rss_feed),
            label: const Text("Fetch RSS Feed"),
            onPressed: _autoFetchRss,
          ),
        ],
      ),
    );
  }
}
