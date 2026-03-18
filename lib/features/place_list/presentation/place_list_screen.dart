import 'package:flutter/material.dart';

import '../../../models/place_candidate.dart';
import '../../../models/search_condition.dart';
import '../../../mock/mock_place_candidates.dart';

class PlaceListScreen extends StatelessWidget {
  const PlaceListScreen({
    super.key,
    required this.condition,
  });

  final SearchCondition condition;

  @override
  Widget build(BuildContext context) {
    final candidates = mockPlaceCandidates
        .where((item) => item.driveMinutes <= condition.driveMinutes)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('갈 수 있는 장소'),
      ),
      body: candidates.isEmpty
          ? const _EmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: candidates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final candidate = candidates[index];
          return _PlaceCandidateCard(candidate: candidate);
        },
      ),
    );
  }
}

class _PlaceCandidateCard extends StatelessWidget {
  const _PlaceCandidateCard({
    required this.candidate,
  });

  final PlaceCandidate candidate;

  @override
  Widget build(BuildContext context) {
    final place = candidate.place;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${place.name} 선택 → 다음에 코스 리스트 화면으로 연결'),
          ),
        );
      },
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
              place.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${place.region} · ${place.address}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MetaColumn(
                    label: '운전 시간',
                    value: '${candidate.driveMinutes}분',
                  ),
                ),
                Expanded(
                  child: _MetaColumn(
                    label: '거리',
                    value: '${candidate.distanceKm.toStringAsFixed(1)}km',
                  ),
                ),
                Expanded(
                  child: _MetaColumn(
                    label: '체류 추천',
                    value: '${place.recommendedStayMinutes}분',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(label: place.ageFitLabel),
                _InfoChip(label: '유모차 ${_strollerLabel(place.strollerAccess)}'),
                _InfoChip(label: '주차 ${_parkingLabel(place.parkingEase)}'),
                if (place.babyChair) const _InfoChip(label: '아기의자 있음'),
              ],
            ),
          ],
        ),
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          '선택한 운전 시간 안에 갈 수 있는 장소가 아직 없어요.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}