class NDVI {
  final double ndvi;
  final String healthStatus;
  final Map<String, dynamic> contributingFactors;

  NDVI({
    required this.ndvi,
    required this.healthStatus,
    required this.contributingFactors,
  });

  factory NDVI.fromJson(Map<String, dynamic> json) {
    return NDVI(
      ndvi: json['ndvi']?.toDouble() ?? 0.0,
      healthStatus: json['health_status'] ?? 'Unknown',
      contributingFactors: json['contributing_factors'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ndvi': ndvi,
      'health_status': healthStatus,
      'contributing_factors': contributingFactors,
    };
  }
}
