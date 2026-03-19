import '../models/place.dart';

final nationalMuseumKids = Place(
  id: 'place_national_museum_kids',
  name: '국립중앙박물관 어린이박물관 및 야외 전시장 산책로',
  region: '서울 용산구',
  category: '박물관',
  address: '서울특별시 용산구 서빙고로',
  lat: 37.5231,
  lng: 126.9803,
  recommendedStayMinutes: 90,
  strollerAccess: 'easy',
  babyChair: false,
  parkingEase: 'easy',
  ageFitLabel: '24~60개월 적합',
  facilities: ['수유실', '유모차 대여'],
);

final lotteWorldAquarium = Place(
  id: 'place_lotte_aquarium',
  name: '롯데월드 아쿠아리움',
  region: '서울 송파구',
  category: '아쿠아리움',
  address: '서울특별시 송파구 올림픽로',
  lat: 37.5111,
  lng: 127.0982,
  recommendedStayMinutes: 120,
  strollerAccess: 'easy',
  babyChair: true,
  parkingEase: 'medium',
  ageFitLabel: '12개월 이상 추천',
  facilities: ['유모차 대여', '수유실', '엘리베이터', '기저귀 교환대', '무료 주차', '놀이방', '식당가'],
);

final kidsCafeHappyLand = Place(
  id: 'place_kids_cafe_happy',
  name: '해피랜드 키즈카페',
  region: '경기 성남시',
  category: '키즈카페',
  address: '경기도 성남시 분당구 판교로',
  lat: 37.4021,
  lng: 127.1090,
  recommendedStayMinutes: 90,
  strollerAccess: 'easy',
  babyChair: true,
  parkingEase: 'easy',
  ageFitLabel: '6~48개월 적합',
  facilities: ['수유실', '기저귀 교환대', '놀이방', '식당가', '무료 주차'],
);

final dumulmeori = Place(
  id: 'dest_yangpyeong',
  name: '두물머리',
  region: '경기 양평군',
  category: '공원',
  address: '경기도 양평군 양서면',
  lat: 37.545,
  lng: 127.323,
  recommendedStayMinutes: 50,
  strollerAccess: 'easy',
  babyChair: false,
  parkingEase: 'easy',
  ageFitLabel: '12~36개월 적합',
  facilities: ['유모차 접근 쉬움', '무료 주차'],
);

final heyri = Place(
  id: 'dest_paju',
  name: '헤이리 예술마을',
  region: '경기 파주시',
  category: '문화예술',
  address: '경기도 파주시 탄현면',
  lat: 37.789,
  lng: 126.698,
  recommendedStayMinutes: 60,
  strollerAccess: 'medium',
  babyChair: true,
  parkingEase: 'medium',
  ageFitLabel: '18개월 이상 추천',
  facilities: ['식당가', '유모차 접근 가능'],
);

final gapyeongLakePark = Place(
  id: 'dest_gapyeong',
  name: '가평 호수공원',
  region: '경기 가평군',
  category: '공원',
  address: '경기도 가평군 가평읍',
  lat: 37.831,
  lng: 127.509,
  recommendedStayMinutes: 60,
  strollerAccess: 'easy',
  babyChair: false,
  parkingEase: 'easy',
  ageFitLabel: '12~48개월 적합',
  facilities: ['유모차 접근 쉬움', '무료 주차'],
);

final mockPlaces = [
  nationalMuseumKids,
  lotteWorldAquarium,
  kidsCafeHappyLand,
  dumulmeori,
  heyri,
  gapyeongLakePark,
];
