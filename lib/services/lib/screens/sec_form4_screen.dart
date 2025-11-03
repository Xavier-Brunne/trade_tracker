
import 'package:flutter/material.dart';
import '../services/sec_form4_rss_service.dart';

class SecForm4RssScreen extends StatefulWidget {
  @override
  _SecForm4RssScreenState createState() => _SecForm4RssScreenState();
}

class _SecForm4RssScreenState extends State<SecForm4RssScreen> {
  final SecForm4RssService _service = SecForm4RssService();
  bool _isLoading = false;
  List<Map<String, String>> _filings = [];
  String? _error;

  void _fetchFilings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _service.fetchForm4Feed();
      setState(() {
        _filings = results;
      });
    } catch (e) {
      setState(() {
        _error = 'Error fetching RSS feed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SEC Form 4 RSS Feed')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _fetchFilings,
            child: Text('Fetch Latest Filings'),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_error!, style: TextStyle(color: Colors.red)),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filings.length,
                itemBuilder: (context, index) {
                  final filing = _filings[index];
                  return ListTile(
                    title: Text(filing['title'] ?? ''),
                    subtitle: Text('Updated: ${filing['updated']}'),
                    onTap: () {
                      // Future enhancement: open filing['link'] in browser
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
