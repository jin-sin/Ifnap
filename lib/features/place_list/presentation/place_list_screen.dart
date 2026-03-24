import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../mock/mock_place_candidates.dart';
import '../../../models/place_candidate.dart';
import '../../../models/search_condition.dart';
import '../../../providers/planning_session_provider.dart';
import '../../course_list/presentation/course_list_screen.dart';

const Color _kBlue = Color(0xFF2563EB);

const Map<String, IconData> _facilityIcons = {
  '수유실': Icons.child_care,
  '유모차 대여': Icons.accessible_forward,
  '유모차 접근 쉬움': Icons.accessible_forward,
  '유모차 접근 가능': Icons.accessible_forward,
  '엘리베이터': Icons.elevator,
  '기저귀 교환대': Icons.baby_changing_station,
  '무료 주차': Icons.local_parking,
  '놀이방': Icons.toys,
  '식당가': Icons.restaurant,
};

const _kCategories = ['박물관', '아쿠아리움', '키즈카페', '공원', '문화예술'];

class PlaceListScreen extends ConsumerStatefulWidget {
  const PlaceListScreen({super.key});

  @override
  ConsumerState<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends ConsumerState<PlaceListScreen> {
  String _sort = '가까운 순';
  String? _categoryFilter;

  static const _sortOptions = ['가까운 순', '빠른 순', '먼 순'];

  List<PlaceCandidate> _filtered(SearchCondition condition) {
    var list = mockPlaceCandidates
        .where((c) => c.driveMinutes <= condition.driveMinutes)
        .toList();

    if (_categoryFilter != null) {
      list = list.where((c) => c.place.category == _categoryFilter).toList();
    }

    list.sort((a, b) {
      switch (_sort) {
        case '빠른 순':
          return a.driveMinutes.compareTo(b.driveMinutes);
        case '먼 순':
          return b.distanceKm.compareTo(a.distanceKm);
        default:
          return a.distanceKm.compareTo(b.distanceKm);
      }
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(planningSessionProvider);
    final condition = session.condition;

    if (condition == null) {
      return const Scaffold(
        body: Center(child: Text('검색 조건이 없어요.')),
      );
    }

    final candidates = _filtered(condition);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '목적지 후보',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            sort: _sort,
            sortOptions: _sortOptions,
            categoryFilter: _categoryFilter,
            onSortChanged: (v) => setState(() => _sort = v),
            onCategoryChanged: (v) => setState(
              () => _categoryFilter = _categoryFilter == v ? null : v,
            ),
          ),
          Expanded(
            child: candidates.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: candidates.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _PlaceCard(candidate: candidates[i]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

// ──────────────────────────────────────────
// Filter bar
// ──────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.sort,
    required this.sortOptions,
    required this.categoryFilter,
    required this.onSortChanged,
    required this.onCategoryChanged,
  });

  final String sort;
  final List<String> sortOptions;
  final String? categoryFilter;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _SortChip(
              label: '정렬: $sort',
              options: sortOptions,
              onSelected: onSortChanged,
            ),
            const SizedBox(width: 8),
            ..._kCategories.map(
              (cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _CategoryChip(
                  label: cat,
                  selected: categoryFilter == cat,
                  onTap: () => onCategoryChanged(cat),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.options,
    required this.onSelected,
  });

  final String label;
  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet<String>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _SortSheet(options: options),
        );
        if (result != null) onSelected(result);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _kBlue,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  const _SortSheet({required this.options});

  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ...options.map(
            (o) => ListTile(
              title: Text(o),
              onTap: () => Navigator.pop(context, o),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _kBlue : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? _kBlue : const Color(0xFFD0D0D0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: selected ? Colors.white : Colors.black54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// Place card
// ──────────────────────────────────────────

class _PlaceCard extends ConsumerStatefulWidget {
  const _PlaceCard({required this.candidate});

  final PlaceCandidate candidate;

  @override
  ConsumerState<_PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends ConsumerState<_PlaceCard> {
  bool _liked = false;

  static const Map<String, Color> _categoryColors = {
    '박물관': Color(0xFFE8EAF6),
    '아쿠아리움': Color(0xFFE3F2FD),
    '키즈카페': Color(0xFFFFF3E0),
    '공원': Color(0xFFE8F5E9),
    '문화예술': Color(0xFFFCE4EC),
  };

  static const Map<String, IconData> _categoryIcons = {
    '박물관': Icons.account_balance,
    '아쿠아리움': Icons.water,
    '키즈카페': Icons.child_friendly,
    '공원': Icons.park,
    '문화예술': Icons.palette,
  };

  @override
  Widget build(BuildContext context) {
    final place = widget.candidate.place;
    final driveMin = widget.candidate.driveMinutes;
    final bgColor =
        _categoryColors[place.category] ?? const Color(0xFFEEEEEE);
    final catIcon =
        _categoryIcons[place.category] ?? Icons.place;

    return GestureDetector(
      onTap: () {
        ref
            .read(planningSessionProvider.notifier)
            .selectDestination(place);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CourseListScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(catIcon, color: Colors.black38, size: 32),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              place.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.4,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _liked = !_liked),
                            child: Icon(
                              _liked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _liked
                                  ? _kBlue
                                  : const Color(0xFFBDBDBD),
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${place.category} • $driveMin분 거리',
                        style: const TextStyle(
                          color: _kBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        place.region,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (place.facilities.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: place.facilities
                    .map((f) => _FacilityChip(label: f))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FacilityChip extends StatelessWidget {
  const _FacilityChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final icon = _facilityIcons[label] ?? Icons.check_circle_outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────
// Bottom navigation
// ──────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: _kBlue,
      unselectedItemColor: const Color(0xFF9E9E9E),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          activeIcon: Icon(Icons.location_on),
          label: '장소',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: '즐겨찾기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: '마이',
        ),
      ],
      onTap: (_) {},
    );
  }
}

// ──────────────────────────────────────────
// Empty state
// ──────────────────────────────────────────

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
