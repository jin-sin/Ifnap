import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/course_stop.dart';
import '../models/place.dart';
import '../models/search_condition.dart';
import '../models/sleep_alternative.dart';
import 'mock_places.dart';

List<Course> generateMockCourses({
  required SearchCondition condition,
  required Place destination,
}) {
  if (destination.id == 'dest_yangpyeong') {
    return _generateYangpyeongCourses(condition, destination);
  }

  return [];
}

List<Course> _generateYangpyeongCourses(
    SearchCondition condition,
    Place destination,
    ) {
  final courseAStops = [
    CourseStop(
      place: yangpyeongBrunch,
      arrivalLabel: '10:50',
      departureLabel: '12:00',
      driveMinutesFromPrev: 50,
      stayMinutes: 70,
    ),
    CourseStop(
      place: destination,
      arrivalLabel: '12:20',
      departureLabel: '13:10',
      driveMinutesFromPrev: 20,
      stayMinutes: 50,
    ),
    CourseStop(
      place: yangpyeongCafe,
      arrivalLabel: '13:30',
      departureLabel: '14:15',
      driveMinutesFromPrev: 20,
      stayMinutes: 45,
    ),
  ];

  final courseBStops = [
    CourseStop(
      place: yangpyeongRestaurant,
      arrivalLabel: '11:00',
      departureLabel: '12:00',
      driveMinutesFromPrev: 55,
      stayMinutes: 60,
    ),
    CourseStop(
      place: destination,
      arrivalLabel: '12:15',
      departureLabel: '13:05',
      driveMinutesFromPrev: 15,
      stayMinutes: 50,
    ),
    CourseStop(
      place: yangpyeongCafe,
      arrivalLabel: '13:25',
      departureLabel: '14:10',
      driveMinutesFromPrev: 20,
      stayMinutes: 45,
    ),
  ];

  final courseCStops = [
    CourseStop(
      place: yangpyeongViewPoint,
      arrivalLabel: '10:50',
      departureLabel: '11:20',
      driveMinutesFromPrev: 50,
      stayMinutes: 30,
    ),
    CourseStop(
      place: destination,
      arrivalLabel: '11:35',
      departureLabel: '12:20',
      driveMinutesFromPrev: 15,
      stayMinutes: 45,
    ),
    CourseStop(
      place: yangpyeongBrunch,
      arrivalLabel: '12:35',
      departureLabel: '13:30',
      driveMinutesFromPrev: 15,
      stayMinutes: 55,
    ),
  ];

  final sleepAlternatives = [
    SleepAlternative(
      id: 'sleep_y_1',
      title: '뷰 좋은 카페 주차 휴식',
      description: '주차 후 테이크아웃 커피로 차 안에서 쉬기 좋아요.',
      place: yangpyeongBrunch,
      distanceMinutes: 7,
      parkingEase: 'easy',
    ),
    SleepAlternative(
      id: 'sleep_y_2',
      title: '강변 뷰 포인트 잠깐 정차',
      description: '아이가 자는 동안 조용히 머물기 좋아요.',
      place: yangpyeongViewPoint,
      distanceMinutes: 5,
      parkingEase: 'easy',
    ),
  ];

  final results = [
    Course(
      id: 'course_y_1',
      title: '양평 산책 + 브런치 코스',
      theme: '산책 중심',
      destination: destination,
      totalMinutes: 280,
      totalDriveMinutes: 110,
      expectedReturnTime: '14:40',
      stops: courseAStops,
      sleepAlternatives: sleepAlternatives,
      tags: ['낮잠 전환 가능', '부모 휴식 포함'],
    ),
    Course(
      id: 'course_y_2',
      title: '양평 식사 + 카페 코스',
      theme: '식사 중심',
      destination: destination,
      totalMinutes: 285,
      totalDriveMinutes: 110,
      expectedReturnTime: '14:45',
      stops: courseBStops,
      sleepAlternatives: sleepAlternatives,
      tags: ['유모차 이용 편함', '아이 동반 OK'],
    ),
    Course(
      id: 'course_y_3',
      title: '양평 낮잠 대응형 코스',
      theme: '부모 휴식형',
      destination: destination,
      totalMinutes: 235,
      totalDriveMinutes: 100,
      expectedReturnTime: '13:55',
      stops: courseCStops,
      sleepAlternatives: sleepAlternatives,
      tags: ['낮잠 대응형', '부모 휴식 포함'],
    ),
  ];

  final availableMinutes = _calculateAvailableMinutes(
    condition.departureTime,
    condition.returnTime,
  );

  return results.where((course) => course.totalMinutes <= availableMinutes).toList();
}

int _calculateAvailableMinutes(TimeOfDay start, TimeOfDay end) {
  final startMinutes = start.hour * 60 + start.minute;
  final endMinutes = end.hour * 60 + end.minute;
  return endMinutes - startMinutes;
}