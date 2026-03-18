

import 'package:flutter/material.dart';

import 'package:ifnap/mock/mock_courses.dart';
import 'package:ifnap/models/course.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('추천 코스'),
      ),
      body: const Center(
        child: Text('코스가 없습니다.'),
      ),
      // ListView.separated(
      //   padding: const EdgeInsets.all(20),
      //   itemCount: mockCourses.length,
      //   separatorBuilder: (_, __) => const SizedBox(height: 16),
      //   itemBuilder: (context, index) {
      //     final course = mockCourses[index];
      //     return _CourseCard(course: course);
      //   },
      // ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final placeNames = course.stops.map((stop) => stop.place.name).join(' · ');

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${course.title} 상세 화면은 다음 단계에서 연결할게요.'),
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    course.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF0FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    course.theme,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _InfoChip(label: '낮잠 전환 가능'),
                _InfoChip(label: '부모 휴식 포함'),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _MetaColumn(
                    label: '총 소요시간',
                    value: _formatMinutes(course.totalMinutes),
                  ),
                ),
                Expanded(
                  child: _MetaColumn(
                    label: '운전시간',
                    value: _formatMinutes(course.totalDriveMinutes),
                  ),
                ),
                Expanded(
                  child: _MetaColumn(
                    label: '예상 귀가',
                    value: course.expectedReturnTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              '대표 장소',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              placeNames,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
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
                  '코스 보기',
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
}

class _MetaColumn extends StatelessWidget {
  const _MetaColumn({required this.label, required this.value});

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
  const _InfoChip({required this.label});

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