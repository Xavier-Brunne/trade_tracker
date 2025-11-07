import 'package:hive/hive.dart';

part 'person.g.dart'; // ✅ required

@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  final String name;

  Person({required this.name});
}
