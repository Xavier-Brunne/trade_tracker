
class SecFiling {
  final String accessionNumber;
  final String filingDate;
  final String reportDate;
  final String issuer;
  bool isSaved; // Used to track if the user bookmarked this filing

  SecFiling({
    required this.accessionNumber,
    required this.filingDate,
    required this.reportDate,
    required this.issuer,
    this.isSaved = false,
  });

  // Optional: Create from JSON if needed
  factory SecFiling.fromJson(Map<String, dynamic> json, String issuerName) {
    return SecFiling(
      accessionNumber: json['accessionNumber'],
      filingDate: json['filingDate'],
      reportDate: json['reportDate'],
      issuer: issuerName,
    );
  }

  // Optional: Convert to JSON (useful for saving locally)
  Map<String, dynamic> toJson() {
    return {
      'accessionNumber': accessionNumber,
      'filingDate': filingDate,
      'reportDate': reportDate,
      'issuer': issuer,
      'isSaved': isSaved,
    };
  }
}
