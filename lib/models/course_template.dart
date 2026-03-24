enum CourseTemplateType {
  walkAndBrunch,
  mealAndCafe,
  sleepFriendly,
}

class CourseTemplate {
  const CourseTemplate({
    required this.type,
    required this.title,
    required this.theme,
  });

  final CourseTemplateType type;
  final String title;
  final String theme;
}