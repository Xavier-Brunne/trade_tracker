
import 'package:flutter/material.dart';
import '../models/sec_filing.dart';
import '../widgets/filing_card.dart';

class SavedFilingsScreen extends StatelessWidget {
  final List<SecFiling> allFilings;

  const SavedFilingsScreen({Key? key, required this.allFilings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedFilings = allFilings.where((filing) => filing.isSaved).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Filings'),
      ),
      body: savedFilings.isEmpty
          ? Center(
              child: Text(
                'No saved filings yet.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: savedFilings.length,
              itemBuilder: (context, index) {
                return FilingCard(filing: savedFilings[index]);
              },
            ),
    );
  }
}
