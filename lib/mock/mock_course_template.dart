import '../models/course_template.dart';

const mockCourseTemplates = [
  CourseTemplate(
    type: CourseTemplateType.walkAndBrunch,
    title: '산책 + 브런치 코스',
    theme: '산책 중심',
  ),
  CourseTemplate(
    type: CourseTemplateType.mealAndCafe,
    title: '식사 + 카페 코스',
    theme: '식사 중심',
  ),
  CourseTemplate(
    type: CourseTemplateType.sleepFriendly,
    title: '낮잠 대응형 코스',
    theme: '부모 휴식형',
  ),
];