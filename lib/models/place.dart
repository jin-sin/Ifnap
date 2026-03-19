class Place {
  const Place({
    required this.id,
    required this.name,
    required this.region,
    required this.category,
    required this.address,
    required this.lat,
    required this.lng,
    required this.recommendedStayMinutes,
    required this.strollerAccess,
    required this.babyChair,
    required this.parkingEase,
    required this.ageFitLabel,
    this.facilities = const [],
  });

  final String id;
  final String name;
  final String region;
  final String category;
  final String address;
  final double lat;
  final double lng;
  final int recommendedStayMinutes;

  final String strollerAccess;
  final bool babyChair;
  final String parkingEase;
  final String ageFitLabel;
  final List<String> facilities;
}