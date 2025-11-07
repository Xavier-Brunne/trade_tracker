import 'package:flutter/material.dart';
import 'package:hive/hive.dart'; // ✅ Needed for Box<Person>
import '../../person.dart';
import '../../screens/sec_form4_screen.dart';
import '../../services/hive_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Box<Person> peopleBox;

  @override
  void initState() {
    super.initState();
    peopleBox = HiveService.getBox<Person>('people'); // ✅ Type-safe access
  }

  void _addPerson() {
    final newPerson = Person(name: 'Darren ${DateTime.now().second}');
    peopleBox.add(newPerson);
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final people = peopleBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          _secFilingsCard(context),
          Expanded(
            child: people.isEmpty
                ? const Center(
                    child: Text("No people added yet. Tap + to add one."))
                : ListView.builder(
                    itemCount: people.length,
                    itemBuilder: (context, index) {
                      final person = people[index];
                      return ListTile(
                        title: Text(person.name),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPerson,
        child: const Icon(Icons.add),
      ),
    );
  }
}
