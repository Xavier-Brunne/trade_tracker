import 'package:hive/hive.dart';

// Import all Hive models
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';
import 'package:trade_tracker/models/settings.dart';
import 'package:trade_tracker/models/cik_cache_entry.dart';
import 'package:trade_tracker/models/trade.dart';
import 'package:trade_tracker/models/portfolio.dart';
import 'package:trade_tracker/models/user_prefs.dart';

/// Registers all Hive adapters used in the app.
/// Call this once before opening any boxes (e.g. in main.dart or test setUpAll).
///
/// TypeId mapping (must stay consistent across builds):
/// 0 → Person
/// 1 → SecFiling
/// 2 → Settings
/// 3 → CikCacheEntry
/// 4 → Trade
/// 5 → Portfolio
/// 6 → UserPrefs
void registerHiveAdapters() {
  // Guard against double registration
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(PersonAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(SecFilingAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(SettingsAdapter());
  if (!Hive.isAdapterRegistered(3))
    Hive.registerAdapter(CikCacheEntryAdapter());
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(TradeAdapter());
  if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(PortfolioAdapter());
  if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(UserPrefsAdapter());
}
