import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/services/hive_service.dart';

class SecSplashScreen extends StatefulWidget {
  final HiveService hiveService;
  const SecSplashScreen({Key? key, required this.hiveService})
      : super(key: key);

  @override
  State<SecSplashScreen> createState() => _SecSplashScreenState();
}

class _SecSplashScreenState extends State<SecSplashScreen> {
  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    // Register adapters safely
    if (!Hive.isAdapterRegistered(PersonAdapter().typeId)) {
      Hive.registerAdapter(PersonAdapter());
    }
    if (!Hive.isAdapterRegistered(SecFilingAdapter().typeId)) {
      Hive.registerAdapter(SecFilingAdapter());
    }

    // Open required boxes
    await Hive.openBox<Person>('people');
    await Hive.openBox<SecFiling>('secFilings');
    await Hive.openBox('settings');
    await Hive.openBox('cikCache');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
