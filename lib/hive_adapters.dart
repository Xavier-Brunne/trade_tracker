import 'package:hive/hive.dart';
import 'package:trade_tracker/models/person.dart';
import 'package:trade_tracker/models/sec_filing.dart';

/// Registers all Hive adapters used in the app.
/// Call this once before opening any boxes.
void registerHiveAdapters() {
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(SecFilingAdapter());
  // Add more adapters here as you create new models
}
