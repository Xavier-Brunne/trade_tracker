import 'package:hive/hive.dart';

part 'sec_filing.g.dart';

@HiveType(typeId: 1)
class SecFiling extends HiveObject {
  @HiveField(0)
  final String accessionNumber;

  @HiveField(1)
  final String filingDate;

  @HiveField(2)
  final String reportDate;

  @HiveField(3)
  final String issuer;

  @HiveField(4)
  bool isSaved;

  @HiveField(5)
  final String source; // 'rss' or 'json'

  // 🔧 Extra optional fields for UI/detail screens
  @HiveField(6)
  final String? cik;

  @HiveField(7)
  final String? transactionType;

  @HiveField(8)
  final String? rawData;

  SecFiling({
    required this.accessionNumber,
    required this.filingDate,
    required this.reportDate,
    required this.issuer,
    this.isSaved = false,
    this.source = 'json',
    this.cik,
    this.transactionType,
    this.rawData,
  });

  factory SecFiling.fromJson(Map<String, dynamic> json, {String? issuerName}) {
    return SecFiling(
      accessionNumber: json['accessionNumber'] ?? '',
      filingDate: json['filingDate'] ?? '',
      reportDate: json['reportDate'] ?? '',
      issuer: issuerName ?? json['issuer'] ?? '',
      isSaved: json['isSaved'] ?? false,
      source: json['source'] ?? 'json',
      cik: json['cik'],
      transactionType: json['transactionType'],
      rawData: json['rawData'],
    );
  }

  Map<String, dynamic> toJson() => {
        'accessionNumber': accessionNumber,
        'filingDate': filingDate,
        'reportDate': reportDate,
        'issuer': issuer,
        'isSaved': isSaved,
        'source': source,
        'cik': cik,
        'transactionType': transactionType,
        'rawData': rawData,
      };
}
