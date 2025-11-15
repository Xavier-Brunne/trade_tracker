import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/models/settings.dart';
import 'package:trade_tracker/models/cik_cache_entry.dart';
import 'package:trade_tracker/models/trade.dart';
import 'package:trade_tracker/models/portfolio.dart';
import 'package:trade_tracker/models/user_prefs.dart';

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
    // Only wipe if you know typeIds changed — prevents stale schema errors
    // await Hive.deleteBoxFromDisk('people');
    // await Hive.deleteBoxFromDisk('secFilings');
    // await Hive.deleteBoxFromDisk('settings');
    // await Hive.deleteBoxFromDisk('cikCache');
    // await Hive.deleteBoxFromDisk('trades');
    // await Hive.deleteBoxFromDisk('portfolios');
    // await Hive.deleteBoxFromDisk('userPrefs');
  }

  // Open boxes via HiveService
  final hiveService = HiveService();
  await hiveService.openBox<Person>('people');
  await hiveService.openBox<SecFiling>('secFilings');
  await hiveService.openBox<Settings>('settings');
  await hiveService.openBox<CikCacheEntry>('cikCache');
  await hiveService.openBox<Trade>('trades');
  await hiveService.openBox<Portfolio>('portfolios');
  await hiveService.openBox<UserPrefs>('userPrefs');

  // ✅ Temporary debug snippet
  final filingsBox = hiveService.getBox<SecFiling>('secFilings');
  debugPrint('DEBUG: SecFilings box contains ${filingsBox.length} filings');

  runApp(TradeTrackerApp(hiveService: hiveService));
}

class TradeTrackerApp extends StatelessWidget {
  final HiveService hiveService;

  const TradeTrackerApp({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardScreen(hiveService: hiveService),
    );
  }
}
