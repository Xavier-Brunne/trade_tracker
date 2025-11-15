import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/services/mock_filing_generator.dart';
import 'package:trade_tracker/services/sec_filings_service.dart';
import 'package:trade_tracker/services/cik_lookup_service.dart';
import 'package:trade_tracker/screens/filing_detail_screen.dart';
import 'package:trade_tracker/screens/sec_form4_screen.dart';

class DashboardScreen extends StatefulWidget {
  final HiveService hiveService;

  const DashboardScreen({super.key, required this.hiveService});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late Box<SecFiling> filingsBox;
  late TabController _tabController;
  bool _loading = false;
  final _tickerController = TextEditingController();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    filingsBox = widget.hiveService.getBox<SecFiling>('secFilings');
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  /// Fetch live SEC filings for a given ticker and cache them in Hive.
  Future<void> _fetchLiveFilingsForTicker(String ticker) async {
    setState(() => _loading = true);
    final cikLookup = CikLookupService(widget.hiveService); // ✅ FIXED
    final filingsService =
        SecFilingsService(hiveService: widget.hiveService); // ✅ FIXED

    try {
      debugPrint('DEBUG: Starting fetch for ticker $ticker');

      final cik = await cikLookup.getCikForTicker(ticker);
      debugPrint('DEBUG: Lookup for $ticker returned CIK = $cik');

      if (cik == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticker $ticker not found')),
        );
        return;
      }

      debugPrint('DEBUG: Fetching filings for CIK $cik');
      await filingsService.fetchAndCacheFilings(cik);

      final box = widget.hiveService.getBox<SecFiling>('secFilings');
      debugPrint('DEBUG: Box now contains ${box.length} filings after fetch');

      setState(() {});
    } catch (e) {
      debugPrint('ERROR: Exception while fetching filings for $ticker → $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch filings: $e')),
      );
    } finally {
      setState(() => _loading = false);
      debugPrint('DEBUG: Fetch process finished for $ticker');
    }
  }

  List<SecFiling> _applySearch(List<SecFiling> filings) {
    if (_searchQuery.isEmpty) return filings;
    return filings.where((f) {
      return f.issuer.toLowerCase().contains(_searchQuery) ||
          f.formType.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Widget _buildFilingList(List<SecFiling> filings) {
    final filteredFilings = _applySearch(filings);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (filteredFilings.isEmpty) {
      return const Center(child: Text('No filings available'));
    }

    return ListView.builder(
      itemCount: filteredFilings.length,
      itemBuilder: (context, index) {
        final filing = filteredFilings[index];
        return ListTile(
          title: Text(
            filing.issuer.isNotEmpty ? filing.issuer : 'Unknown Issuer',
          ),
          subtitle: Text(
            '${filing.formType} • ${filing.filingDate}\n${filing.description ?? ""}',
          ),
          trailing: filing.isSaved
              ? const Icon(Icons.bookmark, color: Colors.green)
              : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FilingDetailScreen(
                  filing: filing,
                  hiveService: widget.hiveService,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _clearSavedFilings() async {
    final savedFilings =
        filingsBox.values.where((f) => f.isSaved).toList(growable: false);
    for (final filing in savedFilings) {
      final updated = filing.copyWith(isSaved: false);
      await widget.hiveService.putFiling(updated);
    }
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All saved filings cleared')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allFilings = filingsBox.values.toList();
    final savedFilings = allFilings.where((f) => f.isSaved).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Trade Tracker Dashboard (${allFilings.length})'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: 'All Filings'),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Saved Filings'),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: savedFilings.isEmpty ? Colors.grey : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      savedFilings.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search filings (issuer or form type)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFilingList(allFilings),
                Column(
                  children: [
                    Expanded(child: _buildFilingList(savedFilings)),
                    if (savedFilings.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear Saved Filings'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: _clearSavedFilings,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            heroTag: 'addMock',
            icon: const Icon(Icons.add),
            label: const Text('Add Mock Filing'),
            onPressed: () {
              final mock = MockFilingGenerator.generate();
              filingsBox.put(mock.id, mock);
              setState(() {});
            },
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'addForm4',
            icon: const Icon(Icons.edit),
            label: const Text('New Form 4'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SecForm4Screen(hiveService: widget.hiveService),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'fetchTicker',
            icon: const Icon(Icons.search),
            label: const Text('Fetch by Ticker'),
            onPressed: () async {
              final ticker = _tickerController.text.trim();
              if (ticker.isNotEmpty) {
                await _fetchLiveFilingsForTicker(ticker);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a ticker')),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _tickerController,
          decoration: const InputDecoration(
            labelText: 'Enter ticker',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
