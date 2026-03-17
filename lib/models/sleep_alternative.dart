import 'place.dart';

class SleepAlternative {
  const SleepAlternative({
    required this.id,
    required this.title,
    required this.description,
    required this.place,
    required this.distanceMinutes,
    required this.parkingEase,
  });

  final String id;
  final String title;
  final String description;
  final Place place;
  final int distanceMinutes;
  final String parkingEase;
}