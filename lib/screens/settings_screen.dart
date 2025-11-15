import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box settingsBox;
  final TextEditingController _tickerController = TextEditingController();
  int _refreshInterval = 0; // minutes

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('settings');
    _tickerController.text =
        settingsBox.get('defaultTicker', defaultValue: 'AAPL');
    _refreshInterval = settingsBox.get('refreshInterval', defaultValue: 0);
  }

  void _saveSettings() {
    final ticker = _tickerController.text.trim();
    if (ticker.isNotEmpty) {
      settingsBox.put('defaultTicker', ticker);
    }
    settingsBox.put('refreshInterval', _refreshInterval);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Settings saved: Default=$ticker, Refresh=${_refreshInterval}m',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tickerController,
              decoration: const InputDecoration(
                labelText: 'Default Ticker Symbol',
                hintText: 'e.g. AAPL, TSLA, MSFT',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Refresh Interval (minutes):'),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: _refreshInterval,
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Off')),
                    DropdownMenuItem(value: 5, child: Text('5')),
                    DropdownMenuItem(value: 15, child: Text('15')),
                    DropdownMenuItem(value: 30, child: Text('30')),
                    DropdownMenuItem(value: 60, child: Text('60')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _refreshInterval = val);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
