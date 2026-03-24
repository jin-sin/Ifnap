import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/planning_session_provider.dart';
import '../../../models/search_condition.dart';
import '../../place_list/presentation/place_list_screen.dart';
import '../../map/presentation/widget/ifnap_map_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TimeOfDay _departureTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _returnTime = const TimeOfDay(hour: 17, minute: 0);
  int _childAgeMonths = 18;
  int _driveMinutes = 60;

  Future<void> _pickTime({required bool isDeparture}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isDeparture ? _departureTime : _returnTime,
    );
    if (picked == null) return;
    setState(() {
      if (isDeparture) {
        _departureTime = picked;
      } else {
        _returnTime = picked;
      }
    });
  }

  void _submit() {
    final condition = SearchCondition(
      originLabel: '내 위치',
      departureTime: _departureTime,
      returnTime: _returnTime,
      childAgeMonths: _childAgeMonths,
      driveMinutes: _driveMinutes,
    );

    ref.read(planningSessionProvider.notifier).setCondition(condition);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PlaceListScreen(),
      ),
    );
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + search card
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '오늘 아이와\n어디 갈까요?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Search card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 25,
                          offset: Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 10,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location field
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 20,
                                color: Color(0xFF6B6B80),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '출발 위치',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF9B9BAE),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '내 위치',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Time + Age row
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.access_time_rounded,
                              label: _formatTime(_departureTime),
                              onTap: () => _pickTime(isDeparture: true),
                            ),
                            const SizedBox(width: 10),
                            _InfoChip(
                              icon: Icons.access_time_rounded,
                              label: _formatTime(_returnTime),
                              onTap: () => _pickTime(isDeparture: false),
                            ),
                            const SizedBox(width: 10),
                            _InfoChip(
                              icon: Icons.person_outline_rounded,
                              label: '$_childAgeMonths개월',
                              onTap: _pickAge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Drive distance
                        const Text(
                          '최대 이동 거리',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [40, 60, 90].map((minutes) {
                            final selected = _driveMinutes == minutes;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _driveMinutes = minutes),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFF6C63FF)
                                        : const Color(0xFFF3F3F5),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '$minutes분',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xFF6B6B80),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        // CTA button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A1A2E),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '코스 찾기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Map below the search card (현위치 shown via Mapbox location puck)
            Expanded(
              child: IfnapMapView(
                initialZoom: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickAge() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            '아이 나이',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...[12, 18, 24, 36, 48].map(
            (month) => ListTile(
              title: Text('$month개월'),
              trailing: _childAgeMonths == month
                  ? const Icon(Icons.check, color: Color(0xFF6C63FF))
                  : null,
              onTap: () {
                setState(() => _childAgeMonths = month);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F5),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF6B6B80)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
