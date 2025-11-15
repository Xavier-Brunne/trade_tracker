import 'package:hive/hive.dart';

part 'sec_filing.g.dart';

@HiveType(typeId: 1) // ensure unique across your app
class SecFiling extends HiveObject {
  // Core, non-nullable
  @HiveField(0)
  final String id; // prefer accessionNumber as id

  @HiveField(1)
  final String issuer;

  @HiveField(2)
  final String filingDate; // YYYY-MM-DD

  @HiveField(3)
  final String accessionNumber;

  @HiveField(4)
  final String formType; // 10-K, 10-Q, 8-K, 4, etc.

  @HiveField(5)
  final DateTime? reportDate; // optional for general filings

  @HiveField(6)
  final bool isSaved;

  @HiveField(7)
  final String source; // 'json', 'rss', 'mock', etc.

  @HiveField(8)
  final String?
      cik; // optional for legacy callers; factories will require/set it

  // Insider-specific (Form 4) optional fields
  @HiveField(9)
  final String? insiderName;

  @HiveField(10)
  final String? insiderCik;

  @HiveField(11)
  final String? transactionCode;

  @HiveField(12)
  final int? transactionShares;

  @HiveField(13)
  final double? transactionPrice;

  // General metadata
  @HiveField(14)
  final String? documentUrl;

  @HiveField(15)
  final String? description;

  @HiveField(16)
  final List<String>? relatedTickers;

  SecFiling({
    required this.id,
    required this.issuer,
    required this.filingDate,
    required this.accessionNumber,
    required this.formType,
    required this.source,
    this.cik, // now optional for legacy constructors
    this.reportDate,
    this.isSaved = false,
    this.insiderName,
    this.insiderCik,
    this.transactionCode,
    this.transactionShares,
    this.transactionPrice,
    this.documentUrl,
    this.description,
    this.relatedTickers,
  });

  /// Factory for Form 4 filings — requires CIK
  factory SecFiling.form4({
    required String accessionNumber,
    required String issuer,
    required String filingDate,
    required String source,
    required String cik,
    String? documentUrl,
    String? insiderName,
    String? insiderCik,
    String? transactionCode,
    int? transactionShares,
    double? transactionPrice,
    String? description,
    List<String>? relatedTickers,
  }) {
    return SecFiling(
      id: accessionNumber,
      accessionNumber: accessionNumber,
      issuer: issuer,
      filingDate: filingDate,
      formType: '4',
      source: source,
      cik: cik,
      documentUrl: documentUrl,
      insiderName: insiderName,
      insiderCik: insiderCik,
      transactionCode: transactionCode,
      transactionShares: transactionShares,
      transactionPrice: transactionPrice,
      description: description,
      relatedTickers: relatedTickers,
      isSaved: false,
    );
  }

  /// Factory for general filings — requires CIK
  factory SecFiling.general({
    required String accessionNumber,
    required String issuer,
    required String filingDate,
    required String formType,
    required String source,
    required String cik,
    String? documentUrl,
    DateTime? reportDate,
    String? description,
    List<String>? relatedTickers,
  }) {
    return SecFiling(
      id: accessionNumber,
      accessionNumber: accessionNumber,
      issuer: issuer,
      filingDate: filingDate,
      formType: formType,
      source: source,
      cik: cik,
      documentUrl: documentUrl,
      reportDate: reportDate,
      description: description,
      relatedTickers: relatedTickers,
      isSaved: false,
    );
  }

  /// Immutable update helper
  SecFiling copyWith({
    String? id,
    String? issuer,
    String? filingDate,
    String? accessionNumber,
    String? formType,
    DateTime? reportDate,
    bool? isSaved,
    String? source,
    String? cik,
    String? insiderName,
    String? insiderCik,
    String? transactionCode,
    int? transactionShares,
    double? transactionPrice,
    String? documentUrl,
    String? description,
    List<String>? relatedTickers,
  }) {
    return SecFiling(
      id: id ?? this.id,
      issuer: issuer ?? this.issuer,
      filingDate: filingDate ?? this.filingDate,
      accessionNumber: accessionNumber ?? this.accessionNumber,
      formType: formType ?? this.formType,
      reportDate: reportDate ?? this.reportDate,
      isSaved: isSaved ?? this.isSaved,
      source: source ?? this.source,
      cik: cik ?? this.cik,
      insiderName: insiderName ?? this.insiderName,
      insiderCik: insiderCik ?? this.insiderCik,
      transactionCode: transactionCode ?? this.transactionCode,
      transactionShares: transactionShares ?? this.transactionShares,
      transactionPrice: transactionPrice ?? this.transactionPrice,
      documentUrl: documentUrl ?? this.documentUrl,
      description: description ?? this.description,
      relatedTickers: relatedTickers ?? this.relatedTickers,
    );
  }
}
