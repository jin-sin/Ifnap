import 'place.dart';

class PlaceCandidate {
  const PlaceCandidate({
    required this.place,
    required this.driveMinutes,
    required this.distanceKm,
  });

  final Place place;
  final int driveMinutes;
  final double distanceKm;
}