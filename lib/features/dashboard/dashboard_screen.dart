import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../person.dart';
import '../../models/sec_filing.dart';
import '../../screens/sec_form4_screen.dart';
import '../../services/hive_service.dart';
import '../../services/mock_filing_generator.dart'; // ✅ corrected path

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Box<Person> peopleBox;
  late Box<SecFiling> secBox;

  @override
  void initState() {
    super.initState();
    peopleBox = HiveService.getBox<Person>('people');
    secBox = HiveService.getBox<SecFiling>('secFilings');
  }

  void _addPerson() {
    final newPerson = Person(name: 'Darren ${DateTime.now().second}');
    peopleBox.add(newPerson);
    setState(() {});
  }

  void _addMockFiling() {
    final mock =
        MockFilingGenerator.generate(issuer: 'Darren ${secBox.length + 1}');
    secBox.add(mock);
    setState(() {});
    print('📄 Added mock filing: ${mock.issuer}');
  }

  Widget _secFilingsCard(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SecForm4Screen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.article, size: 32, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Latest SEC Filings",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Tap to view recent insider trades",
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _secFilingsList() {
    return ValueListenableBuilder(
      valueListenable: secBox.listenable(),
      builder: (context, Box<SecFiling> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text('No filings yet.'));
        }

        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final filing = box.getAt(index);
            if (filing == null) return const SizedBox.shrink();
            return ListTile(
              leading: const Icon(Icons.article),
              title: Text(filing.issuer),
              subtitle: Text('Filed on ${filing.filingDate}'),
              trailing: Text(filing.source),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          _secFilingsCard(context),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Filings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(child: _secFilingsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMockFiling,
        child: const Icon(Icons.add),
        tooltip: 'Add mock SEC filing',
      ),
    );
  }
}
