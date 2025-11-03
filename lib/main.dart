
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/filings_screen.dart';
import 'screens/holdings_screen.dart';

void main() {
  runApp(const TradeTrackerApp());
}

class TradeTrackerApp extends StatelessWidget {
  const TradeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TradeTracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DashboardScreen(),
      routes: {
        '/filings': (context) => const FilingsScreen(),
        '/holdings': (context) => const HoldingsScreen(),
      },
    );
  }
}
