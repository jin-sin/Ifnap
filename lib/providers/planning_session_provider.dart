import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_course_generator.dart';
import '../models/course.dart';
import '../models/place.dart';
import '../models/planning_session.dart';
import '../models/search_condition.dart';

final planningSessionProvider =
NotifierProvider<PlanningSessionNotifier, PlanningSession>(
  PlanningSessionNotifier.new,
);

class PlanningSessionNotifier extends Notifier<PlanningSession> {
  @override
  PlanningSession build() {
    return const PlanningSession();
  }

  void setCondition(SearchCondition condition) {
    state = state.copyWith(
      condition: condition,
      clearDestination: true,
      clearCourses: true,
      clearSelectedCourse: true,
      sleepModeEnabled: false,
    );
  }

  void selectDestination(Place destination) {
    final condition = state.condition;
    if (condition == null) return;

    final generatedCourses = generateMockCourses(
      condition: condition,
      destination: destination,
    );

    state = state.copyWith(
      selectedDestination: destination,
      generatedCourses: generatedCourses,
      clearSelectedCourse: true,
      sleepModeEnabled: false,
    );
  }

  void selectCourse(Course course) {
    state = state.copyWith(
      selectedCourse: course,
      sleepModeEnabled: false,
    );
  }

  void enableSleepMode() {
    state = state.copyWith(sleepModeEnabled: true);
  }

  void disableSleepMode() {
    state = state.copyWith(sleepModeEnabled: false);
  }

  void reset() {
    state = const PlanningSession();
  }
}