// import '../models/course.dart';
// import '../models/course_stop.dart';
// import '../models/place.dart';
// import '../models/sleep_alternative.dart';
//
// final placeYangpyeongPark = Place(
//   id: 'p1',
//   name: '두물머리 산책로',
//   category: 'park',
//   address: '경기도 양평군 양서면',
//   recommendedStayMinutes: 50,
//   strollerAccess: 'easy',
//   babyChair: false,
//   parkingEase: 'easy',
//   ageFitLabel: '12~36개월 적합',
// );
//
// final placeBrunchCafe = Place(
//   id: 'p2',
//   name: '양평 브런치 카페',
//   category: 'cafe',
//   address: '경기도 양평군 서종면',
//   recommendedStayMinutes: 70,
//   strollerAccess: 'easy',
//   babyChair: true,
//   parkingEase: 'easy',
//   ageFitLabel: '아이 동반 가능',
// );
//
// final placeKidsCafe = Place(
//   id: 'p3',
//   name: '양평 키즈카페',
//   category: 'kids_cafe',
//   address: '경기도 양평군 양평읍',
//   recommendedStayMinutes: 90,
//   strollerAccess: 'medium',
//   babyChair: true,
//   parkingEase: 'medium',
//   ageFitLabel: '18~48개월 적합',
// );
//
// final mockCourses = [
//   Course(
//     id: 'c1',
//     title: '양평 산책 + 브런치 코스',
//     theme: '산책 중심',
//     totalMinutes: 300,
//     totalDriveMinutes: 90,
//     expectedReturnTime: '16:30',
//     stops: [
//       CourseStop(
//         place: placeYangpyeongPark,
//         arrivalLabel: '11:00',
//         departureLabel: '11:50',
//         driveMinutesFromPrev: 60,
//         stayMinutes: 60,
//       ),
//       CourseStop(
//         place: placeBrunchCafe,
//         arrivalLabel: '12:10',
//         departureLabel: '13:20',
//         driveMinutesFromPrev: 20,
//         stayMinutes: 90,
//       ),
//       CourseStop(
//         place: placeKidsCafe,
//         arrivalLabel: '13:40',
//         departureLabel: '15:10',
//         driveMinutesFromPrev: 20,
//         stayMinutes: 120,
//       ),
//     ],
//     sleepAlternatives: [
//       SleepAlternative(
//         id: 's1',
//         title: '뷰 좋은 카페 주차 휴식',
//         description: '주차 후 테이크아웃 커피로 차 안에서 휴식',
//         place: placeBrunchCafe,
//         distanceMinutes: 7,
//         parkingEase: 'easy',
//       ),
//     ],
//   ),
// ];