import 'package:flutter/material.dart';

class SearchCondition {
  const SearchCondition({
    required this.originLabel,
    required this.departureTime,
    required this.returnTime,
    required this.childAgeMonths,
    required this.driveMinutes,
  });

  final String originLabel;
  final TimeOfDay departureTime;
  final TimeOfDay returnTime;
  final int childAgeMonths;
  final int driveMinutes;
}