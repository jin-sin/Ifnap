import 'place.dart';

class CourseStop {
  const CourseStop({
    required this.place,
    required this.arrivalLabel,
    required this.departureLabel,
    required this.driveMinutesFromPrev,
  });

  final Place place;
  final String arrivalLabel;
  final String departureLabel;
  final int driveMinutesFromPrev;
}