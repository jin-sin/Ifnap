import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/course.dart';
import '../../../providers/planning_session_provider.dart';

const Color _kBlue = Color(0xFF0050D4);
const Color _kPurple = Color(0xFF8E3A8A);
const Color _kBg = Color(0xFFF5F7F9);

// ──────────────────────────────────────────
// Per-theme visual style
// ──────────────────────────────────────────

class _ThemeStyle {
  final List<Color> gradient;
  final Color badgeBg;
  final Color badgeText;
  final Color dotColor;

  const _ThemeStyle({
    required this.gradient,
    required this.badgeBg,
    required this.badgeText,
    required this.dotColor,
  });
}

const _themeStyles = <String, _ThemeStyle>{
  '산책 중심': _ThemeStyle(
    gradient: [Color(0xFF4A6FA5), Color(0xFF7B9CFF)],
    badgeBg: Color(0xFF7B9CFF),
    badgeText: Color(0xFF001E5A),
    dotColor: _kBlue,
  ),
  '식사 중심': _ThemeStyle(
    gradient: [Color(0xFF8B5E3C), Color(0xFFD4956A)],
    badgeBg: Color(0xFFFFD4A3),
    badgeText: Color(0xFF5C2E00),
    dotColor: Color(0xFFB8722A),
  ),
  '부모 휴식형': _ThemeStyle(
    gradient: [Color(0xFF6B1F7A), Color(0xFFBE6BC4)],
    badgeBg: Color(0xFFFE9CF4),
    badgeText: Color(0xFF661466),
    dotColor: _kPurple,
  ),
};

_ThemeStyle _styleFor(String theme) =>
    _themeStyles[theme] ??
    const _ThemeStyle(
      gradient: [Color(0xFF607D8B), Color(0xFF90A4AE)],
      badgeBg: Color(0xFFCFD8DC),
      badgeText: Color(0xFF263238),
      dotColor: Color(0xFF607D8B),
    );

// ──────────────────────────────────────────
// Screen
// ──────────────────────────────────────────

class CourseListScreen extends ConsumerStatefulWidget {
  const CourseListScreen({super.key});

  @override
  ConsumerState<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends ConsumerState<CourseListScreen> {
  String? _themeFilter; // null = 전체

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(planningSessionProvider);
    final allCourses = session.generatedCourses;
    final destination = session.selectedDestination;

    final themes = allCourses.map((c) => c.theme).toSet().toList();

    final courses = _themeFilter == null
        ? allCourses
        : allCourses.where((c) => c.theme == _themeFilter).toList();

    return Scaffold(
      backgroundColor: _kBg,
      appBar: _buildAppBar(destination?.name),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Always-visible search + filter section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: _SearchBar(query: destination?.name ?? ''),
          ),
          const SizedBox(height: 12),
          _ThemeChips(
            themes: themes,
            selected: _themeFilter,
            onSelected: (t) => setState(
              () => _themeFilter = (t.isEmpty || _themeFilter == t) ? null : t,
            ),
          ),
          const SizedBox(height: 16),
          // Course list or empty state
          Expanded(
            child: courses.isEmpty
                ? const _EmptyState()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    children: [
                      ...courses.map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _CourseCard(course: c),
                        ),
                      ),
                      _BentoGrid(destination: destination?.name),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar(String? destinationName) {
    return AppBar(
      backgroundColor: Colors.white.withValues(alpha: 0.85),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black12,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        '추천 코스',
        style: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.black87),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────
// Search bar
// ──────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF1F3),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black45, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              query.isEmpty ? '어디로 가고 싶으세요?' : query,
              style: TextStyle(
                fontSize: 15,
                color: query.isEmpty
                    ? Colors.black38
                    : const Color(0xFF595C5E),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────
// Theme filter chips
// ──────────────────────────────────────────

class _ThemeChips extends StatelessWidget {
  const _ThemeChips({
    required this.themes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> themes;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: const EdgeInsets.fromLTRB(24, 6, 24, 10),
      child: Row(
        children: [
          _Chip(
            label: '전체',
            active: selected == null,
            onTap: () => onSelected(''),
          ),
          const SizedBox(width: 8),
          ...themes.map(
            (t) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _Chip(
                label: t,
                active: selected == t,
                onTap: () => onSelected(t),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? _kBlue : Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: _kBlue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : const Color(0xFF595C5E),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// Course card
// ──────────────────────────────────────────

class _CourseCard extends StatefulWidget {
  const _CourseCard({required this.course});

  final Course course;

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final style = _styleFor(course.theme);
    final placeNames =
        course.stops.map((s) => s.place.name).join(' · ');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero image area ──
          _HeroImage(
            style: style,
            theme: course.theme,
            saved: _saved,
            onSave: () => setState(() => _saved = !_saved),
          ),

          // ── Content ──
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + tags
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C2F31),
                    height: 1.4,
                  ),
                ),
                if (course.tags.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _TagRow(tags: course.tags),
                ],

                const SizedBox(height: 16),

                // Stats row
                _StatsRow(course: course),

                const SizedBox(height: 16),

                // Place names
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: style.dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        placeNames,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF595C5E),
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // CTA button
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${course.title} 상세 화면은 다음 단계에서 연결됩니다.'),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _kBlue,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '코스 상세 보기',
                            style: TextStyle(
                              color: Color(0xFFF1F2FF),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFF1F2FF),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({
    required this.style,
    required this.theme,
    required this.saved,
    required this.onSave,
  });

  final _ThemeStyle style;
  final String theme;
  final bool saved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 192,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: style.gradient,
              ),
            ),
          ),
          // Subtle pattern overlay
          Opacity(
            opacity: 0.08,
            child: Icon(
              Icons.landscape,
              size: 180,
              color: Colors.white,
            ),
          ),
          // Theme badge (top-left)
          Positioned(
            top: 10,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: style.badgeBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                theme,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: style.badgeText,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          // Bookmark button (top-right)
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: onSave,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  saved ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({required this.tags});

  final List<String> tags;

  static const _tagColors = [_kBlue, _kPurple];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (int i = 0; i < tags.length; i++)
          Text(
            '[${tags[i]}]',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _tagColors[i % _tagColors.length],
            ),
          ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Color(0x80E5E9EB),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatCell(
              label: '총 소요',
              value: _fmt(course.totalMinutes),
            ),
          ),
          Expanded(
            child: _StatCell(
              label: '운전',
              value: _fmt(course.totalDriveMinutes),
            ),
          ),
          Expanded(
            child: _StatCell(
              label: '귀가',
              value: course.expectedReturnTime,
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '$m분';
    if (m == 0) return '$h시간';
    return '$h시간 $m분';
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF595C5E),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2C2F31),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────
// Bento grid (Map + Daily Tip)
// ──────────────────────────────────────────

class _BentoGrid extends StatelessWidget {
  const _BentoGrid({this.destination});

  final String? destination;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 192,
      child: Row(
        children: [
          // Map View card (blue)
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: _kBlue,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: _kBlue.withValues(alpha: 0.35),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '지도로\n탐색하기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFF1F2FF),
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 8),
                        Opacity(
                          opacity: 0.8,
                          child: Text(
                            '주변 경로를\n탐색해보세요',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFF1F2FF),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '지도 열기',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF1F2FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Daily Tip card (white)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E9EB)),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '오늘의 팁',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C2F31),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        destination != null
                            ? '$destination 가는 길,\n간식 챙기는 거\n잊지 마세요!'
                            : '아이와 외출 시\n여벌 옷을 꼭\n챙겨보세요!',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF595C5E),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  // Avatar stack
                  Row(
                    children: [
                      for (int i = 0; i < 2; i++)
                        Transform.translate(
                          offset: Offset(i * -8.0, 0),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      Transform.translate(
                        offset: const Offset(-16, 0),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E9EB),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '+12',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2C2F31),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
      unselectedItemColor: const Color(0xFF94A3B8),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore),
          label: '탐색',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.route),
          activeIcon: Icon(Icons.route),
          label: '코스',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          activeIcon: Icon(Icons.bookmark),
          label: '저장',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: '프로필',
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
    return const Center(
      child: Text('이 조건에 맞는 코스가 없어요.'),
    );
  }
}
