import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trade_tracker/services/hive_service.dart';

class MockBox<T> extends Mock implements Box<T> {}

class MockHiveService extends HiveService {
  final Box<dynamic> _mockBox;

  MockHiveService(this._mockBox);

  @override
  Box<T> getBox<T>(String name) => _mockBox as Box<T>;

  @override
  Future<Box<T>> openBox<T>(String name) async => _mockBox as Box<T>;
}
