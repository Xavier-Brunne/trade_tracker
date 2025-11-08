import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/services/mock_filing_generator.dart';
import 'package:trade_tracker/services/sec_service.dart'; // <-- add this
import 'package:trade_tracker/screens/filing_detail_screen.dart';
import 'package:trade_tracker/screens/sec_form4_screen.dart';

class DashboardScreen extends StatefulWidget {
  final HiveService hiveService;

  const DashboardScreen({super.key, required this.hiveService});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Box<Person> peopleBox;
  late Box<SecFiling> filingsBox;

  @override
  void initState() {
    super.initState();
    peopleBox = widget.hiveService.getBox<Person>('people');
    filingsBox = widget.hiveService.getBox<SecFiling>('secFilings');
  }

  void _openFilingDetail(SecFiling filing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilingDetailScreen(
          filing: filing,
          hiveService: widget.hiveService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: ValueListenableBuilder<Box<SecFiling>>(
        valueListenable: filingsBox.listenable(),
        builder: (context, box, _) {
          final filings = box.values.toList();

          if (filings.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  final mock = mockFiling();
                  await filingsBox.put(mock.id, mock);
                },
                child: const Text("Add Mock Filing"),
              ),
            );
          }

          return ListView.builder(
            itemCount: filings.length,
            itemBuilder: (context, index) {
              final filing = filings[index];
              return ListTile(
                title: Text(filing.issuer),
                subtitle: Text("${filing.formType} • ${filing.filingDate}"),
                onTap: () => _openFilingDetail(filing),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'mock',
            onPressed: () {
              final mock = mockFiling();
              widget.hiveService
                  .getBox<SecFiling>('secFilings')
                  .put(mock.id, mock);
            },
            child: const Icon(Icons.bug_report), // mock generator
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'live',
            onPressed: () async {
              final secService = SecService();
              final filings =
                  await secService.fetchCompanyFilings('0000320193'); // Apple
              final box = widget.hiveService.getBox<SecFiling>('secFilings');
              for (final filing in filings) {
                await box.put(filing.id, filing);
              }
            },
            child: const Icon(Icons.cloud_download), // live SEC
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'form4',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SecForm4Screen(hiveService: widget.hiveService),
                ),
              );
            },
            child: const Icon(Icons.add), // manual form entry
          ),
        ],
      ),
    );
  }
}
