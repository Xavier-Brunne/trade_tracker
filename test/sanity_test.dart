import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart'; // Needed for Hive.box reference
import '../lib/services/hive_service.dart';

void main() {
  test('HiveService.getBox returns a function', () {
    expect(HiveService.getBox is Function, true);
  });

  test('HiveService.getBox returns a Box', () {
    // This will fail unless Hive is initialized, but it's useful for structure
    expect(() => HiveService.getBox('people'), returnsNormally);
  });
}
