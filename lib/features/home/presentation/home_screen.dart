import 'package:flutter/material.dart';

import '../../../models/search_condition.dart';
import '../../course_list/presentation/course_list_screen.dart';
import 'widget/section_label.dart';
import 'widget/time_input_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _originController =
  TextEditingController(text: '서울 금천구');

  TimeOfDay _departureTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _returnTime = const TimeOfDay(hour: 17, minute: 0);
  int _childAgeMonths = 18;
  int _driveMinutes = 60;

  @override
  void dispose() {
    _originController.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isDeparture}) async {
    final initialTime = isDeparture ? _departureTime : _returnTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
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
      originLabel: _originController.text.trim(),
      departureTime: _departureTime,
      returnTime: _returnTime,
      childAgeMonths: _childAgeMonths,
      driveMinutes: _driveMinutes,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CourseListScreen(),
        settings: RouteSettings(arguments: condition),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Ifnap',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '아이가 자도 괜찮아요.\n상황에 맞게 코스를 바꿔드릴게요.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Container(
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
                    SectionLabel('출발지'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _originController,
                      decoration: const InputDecoration(
                        hintText: '예: 서울 금천구',
                        prefixIcon: Icon(Icons.place_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TimeInputCard(
                            label: '출발 시간',
                            value: _departureTime.format(context),
                            onTap: () => _pickTime(isDeparture: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TimeInputCard(
                            label: '귀가 시간',
                            value: _returnTime.format(context),
                            onTap: () => _pickTime(isDeparture: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SectionLabel('아이 나이'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD7D3E6)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: _childAgeMonths,
                          items: const [12, 18, 24, 36, 48]
                              .map(
                                (month) => DropdownMenuItem<int>(
                              value: month,
                              child: Text('$month개월'),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _childAgeMonths = value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SectionLabel('운전 시간'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: [40, 60, 90]
                          .map(
                            (minutes) => ChoiceChip(
                          label: Text('$minutes분'),
                          selected: _driveMinutes == minutes,
                          onSelected: (_) {
                            setState(() => _driveMinutes = minutes);
                          },
                        ),
                      )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('코스 찾기'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF0FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.nightlight_round, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '코스 시작 후 20~30분 뒤에 “아이가 자고 있나요?” 알림을 보내고, 낮잠 중이면 부모 휴식 플랜으로 전환할 수 있어요.',
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}