import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/user_prefs.dart';
import 'package:trade_tracker/hive_adapters.dart';

import 'test_hive_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Box<UserPrefs> prefsBox;

  setUpAll(() async {
    // Initialise Hive test environment
    await initTestHive();

    // Register all adapters centrally
    registerHiveAdapters();

    // Open the userPrefs box
    prefsBox = await openTestBox<UserPrefs>('userPrefs');
  });

  tearDownAll(() async {
    // Dispose Hive test environment
    await disposeTestHive();
  });

  group('UserPrefs model', () {
    test('can be stored and retrieved', () async {
      final prefs = UserPrefs(
        notificationsEnabled: true,
        theme: 'dark',
        language: 'en',
      );

      await prefsBox.put('prefs', prefs);
      final retrieved = prefsBox.get('prefs');

      expect(retrieved?.notificationsEnabled, true);
      expect(retrieved?.theme, 'dark');
      expect(retrieved?.language, 'en');
    });
  });
}
