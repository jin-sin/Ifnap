import '../models/place.dart';

final dumulmeori = Place(
  id: 'dest_yangpyeong',
  name: '두물머리',
  region: '양평',
  category: 'destination',
  address: '경기도 양평군 양서면',
  lat: 37.545,
  lng: 127.323,
  recommendedStayMinutes: 50,
  strollerAccess: 'easy',
  babyChair: false,
  parkingEase: 'easy',
  ageFitLabel: '12~36개월 적합',
);

final heyri = Place(
  id: 'dest_paju',
  name: '헤이리 예술마을',
  region: '파주',
  category: 'destination',
  address: '경기도 파주시 탄현면',
  lat: 37.789,
  lng: 126.698,
  recommendedStayMinutes: 60,
  strollerAccess: 'medium',
  babyChair: true,
  parkingEase: 'medium',
  ageFitLabel: '18개월 이상 추천',
);

final gapyeongLakePark = Place(
  id: 'dest_gapyeong',
  name: '가평 호수공원',
  region: '가평',
  category: 'destination',
  address: '경기도 가평군 가평읍',
  lat: 37.831,
  lng: 127.509,
  recommendedStayMinutes: 60,
  strollerAccess: 'easy',
  babyChair: false,
  parkingEase: 'easy',
  ageFitLabel: '12~48개월 적합',
);

final mockPlaces = [
  dumulmeori,
  heyri,
  gapyeongLakePark,
];