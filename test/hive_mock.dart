import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/services/hive_service.dart';

/// Mock HiveService for testing
class MockHiveService extends Mock implements HiveService {}

/// Mock Box<T> for testing
class MockBox<T> extends Mock implements Box<T> {}
