class Place {
  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.stayMinutes,
    required this.strollerAccess,
    required this.babyChair,
    required this.parkingEase,
    required this.ageFitLabel,
  });

  final String id;
  final String name;
  final String category;
  final String address;
  final int stayMinutes;

  final String strollerAccess;
  final bool babyChair;
  final String parkingEase;
  final String ageFitLabel;
}