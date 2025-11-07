import 'package:flutter/material.dart';
import '../models/sec_filing.dart';
import '../services/hive_service.dart';

class SecForm4Screen extends StatefulWidget {
  final HiveService hiveService;

  const SecForm4Screen({super.key, required this.hiveService});

  @override
  State<SecForm4Screen> createState() => _SecForm4ScreenState();
}

class _SecForm4ScreenState extends State<SecForm4Screen> {
  final _issuerController = TextEditingController();
  final _dateController = TextEditingController();
  final _formTypeController = TextEditingController();

  @override
  void dispose() {
    _issuerController.dispose();
    _dateController.dispose();
    _formTypeController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final filing = SecFiling(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      issuer: _issuerController.text,
      filingDate: _dateController.text,
      formType: _formTypeController.text,
    );

    final box = widget.hiveService.getBox<SecFiling>('secFilings');
    await box.put(filing.id, filing);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Form 4 filing saved")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Form 4 Filing")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _issuerController,
              decoration: const InputDecoration(labelText: "Issuer"),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: "Filing Date"),
            ),
            TextField(
              controller: _formTypeController,
              decoration: const InputDecoration(labelText: "Form Type"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save Filing"),
              onPressed: _saveForm,
            ),
          ],
        ),
      ),
    );
  }
}
