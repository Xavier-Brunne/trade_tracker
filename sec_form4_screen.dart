import 'package:flutter/material.dart';
import '../services/sec_form4_service.dart';

class SecForm4Screen extends StatefulWidget {
  @override
  _SecForm4ScreenState createState() => _SecForm4ScreenState();
}

class _SecForm4ScreenState extends State<SecForm4Screen> {
  final SecForm4Service _service = SecForm4Service();
  bool _isLoading = false;
  List<Map<String, dynamic>> _filings = [];

  void _fetchFilings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _service.fetchForm4Filings('0000320193'); // Apple CIK
      setState(() {
        _filings = results;
      });
    } catch (e) {
      print('Error fetching filings: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SEC Form 4 Filings')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _fetchFilings,
            child: Text('Fetch Today's Filings'),
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filings.length,
                itemBuilder: (context, index) {
                  final filing = _filings[index];
                  return ListTile(
                    title: Text('${filing['issuer']}'),
                    subtitle: Text('Filed: ${filing['filingDate']} | Reported: ${filing['reportDate']}'),
                    onTap: () {
                      // Future: Navigate to details or chart
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
