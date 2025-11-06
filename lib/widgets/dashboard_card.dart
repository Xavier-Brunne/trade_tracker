import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String content;

  const DashboardCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(content),
      ),
    );
  }
}