import 'package:flutter/material.dart';

class FilingsScreen extends StatelessWidget {
  const FilingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latest SEC Filings')),
      body: const Center(child: Text('Filings will appear here')),
    );
  }
}
