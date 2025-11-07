import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 2)
class Person {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  const Person({required this.id, required this.name});
}
