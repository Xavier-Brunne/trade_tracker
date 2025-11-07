import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/sec_filing.dart';
import '../../person.dart';
import '../../services/hive_service.dart';
import '../../services/mock_filing_generator.dart';
import '../../screens/filing_detail_screen.dart';
import '../../screens/sec_form4_screen.dart';

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
          hiveService: widget.hiveService, // ✅ pass hiveService
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Tracker Dashboard'),
        actions: [
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
      body: ValueListenableBuilder<Box<SecFiling>>(
        valueListenable: filingsBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No filings available.'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final filing = box.getAt(index);
              if (filing == null) return const SizedBox.shrink();
              return ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text(filing.issuer),
                subtitle: Text('Filed on ${filing.filingDate}'),
                onTap: () => _openFilingDetail(filing),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SecForm4Screen(
                hiveService: widget.hiveService, // ✅ pass hiveService
              ),
            ),
          );
        },
        icon: const Icon(Icons.rss_feed),
        label: const Text("Form 4 Filings"),
      ),
    );
  }
}
