import 'package:hive/hive.dart';

part 'portfolio.g.dart';

@HiveType(typeId: 5) // ✅ unique typeId
class Portfolio {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> tradeIds; // references to Trade IDs

  Portfolio({
    required this.id,
    required this.name,
    required this.tradeIds,
  });
}
