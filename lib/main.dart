import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';
import 'package:trade_tracker/features/dashboard/dashboard_screen.dart';
import 'package:trade_tracker/hive_adapters.dart'; // ✅ central adapter file

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive
  await Hive.initFlutter();

  // Register all adapters in one place
  registerHiveAdapters();

  // 🔧 Dev-mode reset: wipe boxes if typeIds changed
  if (kDebugMode) {
    await Hive.deleteBoxFromDisk('people');
    await Hive.deleteBoxFromDisk('secFilings');
  }

  // Open boxes via HiveService
  final hiveService = HiveService();
  await hiveService.openBox<Person>('people');
  await hiveService.openBox<SecFiling>('secFilings');

  runApp(TradeTrackerApp(hiveService: hiveService));
}

class TradeTrackerApp extends StatelessWidget {
  final HiveService hiveService;

  const TradeTrackerApp({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DashboardScreen(hiveService: hiveService),
    );
  }
}
