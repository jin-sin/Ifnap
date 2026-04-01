import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/planning_session_provider.dart';

class SleepModeScreen extends ConsumerWidget {
  const SleepModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(
      planningSessionProvider.select((state) => state.selectedCourse),
    );

    if (course == null) {
      return const Scaffold(
        body: Center(
          child: Text('선택된 코스가 없어요.'),
        ),
      );
    }

    final alternatives = course.sleepAlternatives;

    return Scaffold(
      appBar: AppBar(
        title: const Text('낮잠 모드'),
      ),
      body: alternatives.isEmpty
          ? const _EmptyState()
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '아이가 자고 있네요 😴',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '지금은 아이를 깨우지 않고, 부모가 잠깐 쉴 수 있는 플랜을 추천해드릴게요.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: const Color(0xFF4B4B63),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...alternatives.map(
                (alternative) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _SleepAlternativeCard(
                title: alternative.title,
                description: alternative.description,
                placeName: alternative.place.name,
                address: alternative.place.address,
                distanceMinutes: alternative.distanceMinutes,
                parkingEase: alternative.parkingEase,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${alternative.title} 플랜을 선택했어요.',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepAlternativeCard extends StatelessWidget {
  const _SleepAlternativeCard({
    required this.title,
    required this.description,
    required this.placeName,
    required this.address,
    required this.distanceMinutes,
    required this.parkingEase,
    required this.onTap,
  });

  final String title;
  final String description;
  final String placeName;
  final String address;
  final int distanceMinutes;
  final String parkingEase;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
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
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4B4B63),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MetaColumn(
                    label: '거리',
                    value: '${distanceMinutes}분',
                  ),
                ),
                Expanded(
                  child: _MetaColumn(
                    label: '주차',
                    value: _parkingLabel(parkingEase),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F7FC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '이 플랜으로 보기',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          '현재 코스에는 낮잠 대안 플랜이 없어요.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}