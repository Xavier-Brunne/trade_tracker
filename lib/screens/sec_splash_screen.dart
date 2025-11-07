import 'package:flutter/material.dart';
import 'package:trade_tracker/services/hive_service.dart';

class SecSplashScreen extends StatelessWidget {
  final HiveService hiveService;

  const SecSplashScreen({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Welcome to TradeTracker')),
    );
  }
}
