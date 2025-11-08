import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trade_tracker/services/hive_service.dart';

/// A mock HiveService for widget/unit tests.
/// Implements the same API as the real HiveService.
class MockHiveService extends Mock implements HiveService {}

/// A mock Box<T> for widget/unit tests.
/// Lets you stub values and methods on Hive boxes.
class MockBox<T> extends Mock implements Box<T> {}
