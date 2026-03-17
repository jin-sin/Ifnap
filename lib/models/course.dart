import 'course_stop.dart';
import 'sleep_alternative.dart';

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.theme,
    required this.totalMinutes,
    required this.totalDriveMinutes,
    required this.expectedReturnTime,
    required this.stops,
    required this.sleepAlternatives,
  });

  final String id;
  final String title;
  final String theme;
  final int totalMinutes;
  final int totalDriveMinutes;
  final String expectedReturnTime;
  final List<CourseStop> stops;
  final List<SleepAlternative> sleepAlternatives;
}