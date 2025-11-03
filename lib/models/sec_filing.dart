
class SecFiling {
  final String accessionNumber;
  final String filingDate;
  final String reportDate;
  final String issuer;
  bool isSaved; // for bookmarking

  SecFiling({
    required this.accessionNumber,
    required this.filingDate,
    required this.reportDate,
    required this.issuer,
    this.isSaved = false,
  });

  factory SecFiling.fromJson(Map<String, dynamic> json, String issuerName) {
    return SecFiling(
      accessionNumber: json['accessionNumber'],
      filingDate: json['filingDate'],
      reportDate: json['reportDate'],
      issuer: issuerName,
    );
  }
}
