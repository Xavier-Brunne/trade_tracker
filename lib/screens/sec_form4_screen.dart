import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../models/sec_filing.dart';

class SecForm4Screen extends StatefulWidget {
  final HiveService hiveService;

  const SecForm4Screen({super.key, required this.hiveService});

  @override
  State<SecForm4Screen> createState() => _SecForm4ScreenState();
}

class _SecForm4ScreenState extends State<SecForm4Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController issuerController = TextEditingController();
  final TextEditingController accessionController = TextEditingController();
  final TextEditingController cikController = TextEditingController(); // ✅ new
  final TextEditingController sharesController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    issuerController.dispose();
    accessionController.dispose();
    cikController.dispose(); // ✅ dispose
    sharesController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final filing = SecFiling.form4(
        accessionNumber: accessionController.text.trim(),
        issuer: issuerController.text.trim(),
        filingDate: DateTime.now().toIso8601String(),
        source: 'manual',
        cik: cikController.text.trim(), // ✅ required argument
        documentUrl: null,
        insiderName: null,
        insiderCik: null,
        transactionCode: 'P', // default Purchase
        transactionShares: int.tryParse(sharesController.text.trim()),
        transactionPrice: double.tryParse(priceController.text.trim()),
      );

      widget.hiveService.getBox<SecFiling>('secFilings').put(filing.id, filing);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form 4 filing saved')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Form 4 Filing')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: issuerController,
                decoration: const InputDecoration(labelText: 'Issuer'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Issuer is required'
                    : null,
              ),
              TextFormField(
                controller: accessionController,
                decoration:
                    const InputDecoration(labelText: 'Accession Number'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Accession number is required'
                    : null,
              ),
              TextFormField(
                controller: cikController,
                decoration:
                    const InputDecoration(labelText: 'CIK'), // ✅ new field
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'CIK is required'
                    : null,
              ),
              TextFormField(
                controller: sharesController,
                decoration: const InputDecoration(labelText: 'Shares'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return 'Enter a valid integer';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save Filing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
