import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'person.dart';
import 'models/sec_filing.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/splash/sec_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // ✅ Register adapters safely
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(PersonAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(SecFilingAdapter());
  }

  // ✅ Open boxes
  await Hive.openBox<Person>('people');
  await Hive.openBox<SecFiling>('secFilings');

  // 🧠 Diagnostics
  final peopleBox = Hive.box<Person>('people');
  print('🔍 Hive box "people" runtimeType: ${peopleBox.runtimeType}');
  print('📁 Hive box path: ${peopleBox.path}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}
