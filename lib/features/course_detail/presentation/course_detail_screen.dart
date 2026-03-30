import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/planning_session_provider.dart';
import '../../map/presentation/widget/ifnap_map_view.dart';
import '../../sleep_mode/presentation/sleep_mode_screen.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(
      planningSessionProvider.select((state) => state.selectedCourse),
    );

    if (course == null) {
      return const Scaffold(
        body: Center(
          child: Text('선택한 코스가 없어요.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              children: [
                _CourseSummaryCard(
                  totalMinutes: course.totalMinutes,
                  totalDriveMinutes: course.totalDriveMinutes,
                  expectedReturnTime: course.expectedReturnTime,
                  theme: course.theme,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 260,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: const IfnapMapView(
                      initialZoom: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '코스 타임라인',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...course.stops.asMap().entries.map(
                      (entry) {
                    final index = entry.key;
                    final stop = entry.value;

                    return _CourseStopTile(
                      index: index + 1,
                      placeName: stop.place.name,
                      address: stop.place.address,
                      arrivalLabel: stop.arrivalLabel,
                      departureLabel: stop.departureLabel,
                      stayMinutes: stop.stayMinutes,
                      driveMinutesFromPrev: stop.driveMinutesFromPrev,
                      strollerAccess: stop.place.strollerAccess,
                      babyChair: stop.place.babyChair,
                      parkingEase: stop.place.parkingEase,
                      ageFitLabel: stop.place.ageFitLabel,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: FilledButton(
          onPressed: () {
            ref.read(planningSessionProvider.notifier).enableSleepMode();

            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => const SleepModeScreen(),
            //   ),
            // );
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A2E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            '아이가 잠들었어요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseSummaryCard extends StatelessWidget {
  const _CourseSummaryCard({
    required this.totalMinutes,
    required this.totalDriveMinutes,
    required this.expectedReturnTime,
    required this.theme,
  });

  final int totalMinutes;
  final int totalDriveMinutes;
  final String expectedReturnTime;
  final String theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TagChip(label: theme),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetaColumn(
                  label: '총 소요시간',
                  value: _formatMinutes(totalMinutes),
                ),
              ),
              Expanded(
                child: _MetaColumn(
                  label: '운전시간',
                  value: _formatMinutes(totalDriveMinutes),
                ),
              ),
              Expanded(
                child: _MetaColumn(
                  label: '예상 귀가',
                  value: expectedReturnTime,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CourseStopTile extends StatelessWidget {
  const _CourseStopTile({
    required this.index,
    required this.placeName,
    required this.address,
    required this.arrivalLabel,
    required this.departureLabel,
    required this.stayMinutes,
    required this.driveMinutesFromPrev,
    required this.strollerAccess,
    required this.babyChair,
    required this.parkingEase,
    required this.ageFitLabel,
  });

  final int index;
  final String placeName;
  final String address;
  final String arrivalLabel;
  final String departureLabel;
  final int stayMinutes;
  final int driveMinutesFromPrev;
  final String strollerAccess;
  final bool babyChair;
  final String parkingEase;
  final String ageFitLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF6C63FF),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MetaColumn(
                        label: '도착',
                        value: arrivalLabel,
                      ),
                    ),
                    Expanded(
                      child: _MetaColumn(
                        label: '출발',
                        value: departureLabel,
                      ),
                    ),
                    Expanded(
                      child: _MetaColumn(
                        label: '체류',
                        value: '${stayMinutes}분',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '이전 장소에서 ${driveMinutesFromPrev}분 이동',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF6B6B80),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _TagChip(label: ageFitLabel),
                    _TagChip(label: '유모차 ${_strollerLabel(strollerAccess)}'),
                    _TagChip(label: '주차 ${_parkingLabel(parkingEase)}'),
                    if (babyChair) const _TagChip(label: '아기의자 있음'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _strollerLabel(String value) {
    switch (value) {
      case 'easy':
        return '편함';
      case 'medium':
        return '보통';
      case 'hard':
        return '어려움';
      default:
        return value;
    }
  }

  String _parkingLabel(String value) {
    switch (value) {
      case 'easy':
        return '편함';
      case 'medium':
        return '보통';
      case 'hard':
        return '불편';
      default:
        return value;
    }
  }
}

class _MetaColumn extends StatelessWidget {
  const _MetaColumn({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2FA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _formatMinutes(int minutes) {
  final hours = minutes ~/ 60;
  final remainMinutes = minutes % 60;

  if (hours == 0) {
    return '${remainMinutes}분';
  }
  if (remainMinutes == 0) {
    return '${hours}시간';
  }
  return '${hours}시간 ${remainMinutes}분';
}