
import 'package:flutter/material.dart';
import '../models/sec_filing.dart';
import '../services/sec_form4_json_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<SecFiling> filings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFilings();
  }

  Future<void> fetchFilings() async {
    try {
      final results = await SecForm4JsonService.fetchForm4Filings('0000320193'); // Example CIK
      setState(() {
        filings = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching filings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TradeTracker'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Holdings Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📊 Your Holdings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('You currently have no holdings.'),
                    TextButton(
                      onPressed: () {
                        // Navigate to add assets screen
                      },
                      child: const Text('Click here to add assets (stocks, cryptos etc)'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // SEC Filings Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📰 Latest SEC Filings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (filings.isEmpty)
                      const Text('No filings found today.')
                    else
                      ...filings.take(3).map((f) => ListTile(
                            title: Text(f.issuer),
                            subtitle: Text('Filed on ${f.filingDate}'),
                            trailing: IconButton(
                              icon: Icon(
                                f.isSaved ? Icons.bookmark : Icons.bookmark_border,
                                color: f.isSaved ? Colors.blue : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  f.isSaved = !f.isSaved;
                                });
                              },
                            ),
                          )),
                    TextButton(
                      onPressed: () {
                        // Navigate to full filings screen
                      },
                      child: const Text('View All Filings'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Market Trends Placeholder
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('📈 Market Trends (Coming Soon)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Charts and analytics will appear here.'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Fetch Button
            Center(
              child: ElevatedButton.icon(
                onPressed: fetchFilings,
                icon: const Icon(Icons.refresh),
                label: const Text('Fetch Today’s Filings'),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Watchlist'),
          BottomNavigationBarItem(icon: Icon(Icons.backup), label: 'Backup'),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
