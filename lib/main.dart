import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(SecFilingAdapter());

  // Open boxes via HiveService
  final hiveService = const HiveService(); // ✅ not const
  await hiveService.openBox<Person>('people');
  await hiveService.openBox<SecFiling>('secFilings');

  runApp(TradeTrackerApp(hiveService: hiveService)); // ✅ not const
}

class TradeTrackerApp extends StatelessWidget {
  final HiveService hiveService;

  const TradeTrackerApp({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DashboardScreen(hiveService: hiveService), // ✅ inject service
    );
  }
}
