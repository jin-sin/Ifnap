import 'course.dart';
import 'place.dart';
import 'search_condition.dart';

class PlanningSession {
  const PlanningSession({
    this.condition,
    this.selectedDestination,
    this.generatedCourses = const [],
    this.selectedCourse,
    this.sleepModeEnabled = false,
  });

  final SearchCondition? condition;
  final Place? selectedDestination;
  final List<Course> generatedCourses;
  final Course? selectedCourse;
  final bool sleepModeEnabled;

  PlanningSession copyWith({
    SearchCondition? condition,
    Place? selectedDestination,
    List<Course>? generatedCourses,
    Course? selectedCourse,
    bool? sleepModeEnabled,
    bool clearDestination = false,
    bool clearCourses = false,
    bool clearSelectedCourse = false,
  }) {
    return PlanningSession(
      condition: condition ?? this.condition,
      selectedDestination:
      clearDestination ? null : (selectedDestination ?? this.selectedDestination),
      generatedCourses: clearCourses ? [] : (generatedCourses ?? this.generatedCourses),
      selectedCourse:
      clearSelectedCourse ? null : (selectedCourse ?? this.selectedCourse),
      sleepModeEnabled: sleepModeEnabled ?? this.sleepModeEnabled,
    );
  }
}