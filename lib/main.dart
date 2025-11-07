import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/sec_filing.dart';
import 'person.dart';
import 'services/hive_service.dart';
import 'features/dashboard/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(SecFilingAdapter());

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
      home: DashboardScreen(hiveService: hiveService), // ✅ inject service
    );
  }
}
