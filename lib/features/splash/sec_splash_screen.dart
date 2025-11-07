import 'package:flutter/material.dart';
import '../../services/hive_service.dart';
import '../dashboard/dashboard_screen.dart';

class SecSplashScreen extends StatelessWidget {
  final HiveService hiveService;

  const SecSplashScreen({super.key, required this.hiveService});

  void _continue(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DashboardScreen(hiveService: hiveService), // ✅ pass hiveService
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Trade Tracker",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _continue(context),
              child: const Text("Continue"), // ✅ const constructor
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(), // ✅ const constructor
          ],
        ),
      ),
    );
  }
}
