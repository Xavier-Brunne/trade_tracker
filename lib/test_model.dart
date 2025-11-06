import 'package:hive/hive.dart';

part 'test_model.g.dart';

@HiveType(typeId: 1)
class TestModel extends HiveObject {
  @HiveField(0)
  String value;

  TestModel({required this.value});
}
