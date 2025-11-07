import 'package:hive/hive.dart';

part 'sec_filing.g.dart'; // ✅ required

@HiveType(typeId: 1)
class SecFiling {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String issuer;

  @HiveField(2)
  final String filingDate;

  @HiveField(3)
  final String formType;

  SecFiling({
    required this.id,
    required this.issuer,
    required this.filingDate,
    required this.formType,
  });
}
