import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show Position;

import '../../../models/course_stop.dart';
import '../../../providers/planning_session_provider.dart';
import '../../map/presentation/widget/ifnap_map_view.dart';
import '../../sleep_mode/presentation/sleep_mode_screen.dart';

const Color _kBlue = Color(0xFF0050D4);
const Color _kBg = Color(0xFFF5F7F9);

const List<Color> _stopColors = [
  Color(0xFF7B9CFF),
  Color(0xFFFE9CF4),
  Color(0xFF0050D4),
  Color(0xFFD4956A),
  Color(0xFFBE6BC4),
];

// ──────────────────────────────────────────
// Screen
// ──────────────────────────────────────────

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(
      planningSessionProvider.select((s) => s.selectedCourse),
    );
    final condition = ref.watch(
      planningSessionProvider.select((s) => s.condition),
    );

    if (course == null) {
      return const Scaffold(
        body: Center(child: Text('선택한 코스가 없어요.')),
      );
    }

    final departureLabel = condition != null
        ? '${condition.departureTime.hour.toString().padLeft(2, '0')}:${condition.departureTime.minute.toString().padLeft(2, '0')}'
        : null;

    return Scaffold(
      backgroundColor: _kBg,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(24, 88, 24, 160),
            children: [
              _HeroSection(title: course.title, tags: course.tags),
              const SizedBox(height: 16),
              _MapCard(
            stops: course.stops,
            markers: course.stops
                .map((s) => Position(s.place.lng, s.place.lat))
                .toList(),
          ),
              const SizedBox(height: 16),
              _SummaryCard(
                totalMinutes: course.totalMinutes,
                totalDriveMinutes: course.totalDriveMinutes,
                expectedReturnTime: course.expectedReturnTime,
              ),
              const SizedBox(height: 32),
              const Text(
                '상세 일정',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C2F31),
                ),
              ),
              const SizedBox(height: 32),
              _Timeline(
                stops: course.stops,
                departureLabel: departureLabel,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomActions(
              onSleepMode: () {
                ref.read(planningSessionProvider.notifier).enableSleepMode();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SleepModeScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: _kBg.withValues(alpha: 0.8),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _NavIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Course Explorer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C2F31),
                          ),
                        ),
                      ),
                      _NavIconButton(
                        icon: Icons.ios_share_outlined,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _NavIconButton(
                        icon: Icons.more_vert_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// Map overlay button (zoom / locate)
// ──────────────────────────────────────────

class _MapOverlayButton extends StatelessWidget {
  const _MapOverlayButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF2C2F31)),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// AppBar button
// ──────────────────────────────────────────

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFD9DDE0).withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}

// ──────────────────────────────────────────
// Hero: title + tags
// ──────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.title, required this.tags});

  final String title;
  final List<String> tags;

  static const _tagBgColors = [
    Color(0xFFD5E3FD),
    Color(0xFFFE9CF4),
    Color(0xFFE5E9EB),
  ];

  static const _tagTextColors = [
    Color(0xFF455367),
    Color(0xFF661466),
    Color(0xFF595C5E),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2C2F31),
            height: 1.25,
            letterSpacing: -0.75,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.asMap().entries.map((e) {
            final i = e.key % _tagBgColors.length;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _tagBgColors[i],
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                e.value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _tagTextColors[i],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────
// Map card with route stop indicators
// ──────────────────────────────────────────

class _MapCard extends StatefulWidget {
  const _MapCard({required this.stops, required this.markers});

  final List<CourseStop> stops;
  final List<Position> markers;

  @override
  State<_MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<_MapCard> {
  final _mapKey = GlobalKey<IfnapMapViewState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E9EB),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: const Color(0xFFD9DDE0).withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 25,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: IfnapMapView(
              key: _mapKey,
              initialZoom: 10,
              markers: widget.markers,
            ),
          ),
          // Zoom + locate buttons (right side)
          Positioned(
            top: 12,
            right: 12,
            child: Column(
              children: [
                _MapOverlayButton(
                  icon: Icons.my_location_rounded,
                  onTap: () => _mapKey.currentState?.flyTo(
                    widget.markers.isNotEmpty
                        ? widget.markers.first
                        : Position(126.9780, 37.5665),
                    zoom: 10,
                  ),
                ),
                const SizedBox(height: 8),
                _MapOverlayButton(
                  icon: Icons.add_rounded,
                  onTap: () => _mapKey.currentState?.zoomIn(),
                ),
                const SizedBox(height: 4),
                _MapOverlayButton(
                  icon: Icons.remove_rounded,
                  onTap: () => _mapKey.currentState?.zoomOut(),
                ),
              ],
            ),
          ),
          // Route stop indicator pills
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: widget.stops.asMap().entries.map((e) {
                  final dotColor = _stopColors[e.key % _stopColors.length];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: dotColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                e.value.place.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2C2F31),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────
// Summary stats card
// ──────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.totalMinutes,
    required this.totalDriveMinutes,
    required this.expectedReturnTime,
  });

  final int totalMinutes;
  final int totalDriveMinutes;
  final String expectedReturnTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD9DDE0).withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _StatCell(
                label: 'Total Time',
                value: _formatMinutes(totalMinutes),
              ),
            ),
            const VerticalDivider(
              color: Color(0xFFE5E9EB),
              width: 18,
              thickness: 1,
            ),
            Expanded(
              child: _StatCell(
                label: 'Driving',
                value: _formatMinutes(totalDriveMinutes),
              ),
            ),
            const VerticalDivider(
              color: Color(0xFFE5E9EB),
              width: 18,
              thickness: 1,
            ),
            Expanded(
              child: _StatCell(
                label: 'Return',
                value: expectedReturnTime,
              ),
            ),
          ],
        ),
      ),
    );
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
            fontWeight: FontWeight.w400,
            color: Color(0xFF595C5E),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2C2F31),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────
// Timeline
// ──────────────────────────────────────────

class _Timeline extends StatelessWidget {
  const _Timeline({required this.stops, this.departureLabel});

  final List<CourseStop> stops;
  final String? departureLabel;

  @override
  Widget build(BuildContext context) {
    final totalItems = (departureLabel != null ? 1 : 0) + stops.length;
    int itemIndex = 0;

    final rows = <Widget>[];

    // Departure item
    if (departureLabel != null) {
      final isLast = totalItems == 1;
      rows.add(
        _TimelineRow(
          isLast: isLast,
          dot: const _GrayDot(),
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 16 : 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departureLabel!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _kBlue,
                  ),
                ),
                const Text(
                  'Start from Home',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C2F31),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      itemIndex++;
    }

    // Stop items
    for (int i = 0; i < stops.length; i++) {
      final isLast = itemIndex == totalItems - 1;
      final dotColor = _stopColors[i % _stopColors.length];

      rows.add(
        _TimelineRow(
          isLast: isLast,
          dot: _ColoredDot(color: dotColor),
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 16 : 48),
            child: _StopCard(stop: stops[i]),
          ),
        ),
      );
      itemIndex++;
    }

    return Column(children: rows);
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.isLast,
    required this.dot,
    required this.child,
  });

  final bool isLast;
  final Widget dot;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Stack(
              children: [
                if (!isLast)
                  Positioned(
                    top: 24,
                    bottom: 0,
                    left: 11,
                    child: const SizedBox(
                      width: 2,
                      child: _DashedLine(),
                    ),
                  ),
                Positioned(top: 6, left: 0, child: dot),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// Timeline dots

class _GrayDot extends StatelessWidget {
  const _GrayDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFDFE3E6),
        shape: BoxShape.circle,
        border: Border.all(color: _kBg, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF747779),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _ColoredDot extends StatelessWidget {
  const _ColoredDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: _kBg, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.place_rounded, size: 10, color: Colors.white),
      ),
    );
  }
}

// Dashed vertical line

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(2, constraints.maxHeight),
          painter: _DashedLinePainter(),
        );
      },
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFABADAF).withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const gapHeight = 4.0;
    double y = 0;

    while (y < size.height) {
      final end = (y + dashHeight).clamp(0.0, size.height);
      canvas.drawLine(Offset(0, y), Offset(0, end), paint);
      y += dashHeight + gapHeight;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
}

// Stop card

class _StopCard extends StatelessWidget {
  const _StopCard({required this.stop});

  final CourseStop stop;

  @override
  Widget build(BuildContext context) {
    final featureTags = _buildFeatureTags(stop);

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD9DDE0).withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: time+name | duration badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop.arrivalLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _kBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stop.place.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C2F31),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF1F3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${stop.stayMinutes} min',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF595C5E),
                  ),
                ),
              ),
            ],
          ),
          if (featureTags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: featureTags
                  .map(
                    (tag) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _FeatureTag(icon: tag.$1, label: tag.$2),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  List<(IconData, String)> _buildFeatureTags(CourseStop stop) {
    final tags = <(IconData, String)>[];
    if (stop.place.babyChair) {
      tags.add((Icons.chair_alt_outlined, '아기의자 있음'));
    }
    if (stop.place.strollerAccess == 'easy') {
      tags.add((Icons.stroller_outlined, '유모차 편함'));
    }
    return tags;
  }
}

class _FeatureTag extends StatelessWidget {
  const _FeatureTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD5E3FD).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF455367)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF455367),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────
// Bottom action bar
// ──────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.onSleepMode});

  final VoidCallback onSleepMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0, 0.5, 1],
          colors: [
            _kBg.withValues(alpha: 0),
            _kBg.withValues(alpha: 0.9),
            _kBg,
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        32,
        24,
        MediaQuery.of(context).padding.bottom + 32,
      ),
      child: Row(
        children: [
          // Save button
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: const Color(0xFFD9DDE0).withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 25,
                  offset: const Offset(0, 20),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_outline_rounded, size: 20, color: Color(0xFF2C2F31)),
                  SizedBox(width: 8),
                  Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2C2F31),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Sleep mode / navigation button
          Expanded(
            child: GestureDetector(
              onTap: onSleepMode,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: _kBlue,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: _kBlue.withValues(alpha: 0.3),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.navigation_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '아이가 잠들었어요',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────
// Helpers
// ──────────────────────────────────────────

String _formatMinutes(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}m';
  if (m == 0) return '${h}h';
  return '${h}h ${m}m';
}
