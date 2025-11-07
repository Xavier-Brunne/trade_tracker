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
  final String accessionNumber;

  @HiveField(4)
  final String formType;

  @HiveField(5)
  final DateTime reportDate;

  @HiveField(6)
  final bool isSaved;

  @HiveField(7)
  final String source;

  const SecFiling({
    required this.id,
    required this.issuer,
    required this.filingDate,
    required this.accessionNumber,
    required this.formType,
    required this.reportDate,
    this.isSaved = false,
    required this.source,
  });
}
