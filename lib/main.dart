import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/sec_filing.dart';
import 'person.dart';
import 'features/dashboard/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive
  await Hive.initFlutter();

  // ✅ Register adapters
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(SecFilingAdapter());

  // ✅ Open boxes before app launch
  await Hive.openBox<Person>('people');
  await Hive.openBox<SecFiling>('secFilings');

  runApp(const TradeTrackerApp());
}

class TradeTrackerApp extends StatelessWidget {
  const TradeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
