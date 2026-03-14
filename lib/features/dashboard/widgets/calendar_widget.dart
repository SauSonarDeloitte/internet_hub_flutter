import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/colors/app_colors.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedMonth;

  static const List<String> _dayLabels = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  int _daysInMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final offset = _focusedMonth.weekday - 1; // Mon=1 → offset=0, Wed=3 → offset=2
    final daysInMonth = _daysInMonth(_focusedMonth);
    final totalCells = offset + daysInMonth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _prevMonth,
            ),
            Expanded(
              child: Text(
                DateFormat('MMMM yyyy').format(_focusedMonth),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _nextMonth,
            ),
          ],
        ),

        // Day-of-week labels row
        Row(
          children: _dayLabels
              .map(
                (label) => Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: 4),

        // Day cells grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: totalCells,
          itemBuilder: (context, index) {
            if (index < offset) {
              return const SizedBox.shrink();
            }

            final day = index - offset + 1;
            final cellDate = DateTime(_focusedMonth.year, _focusedMonth.month, day);
            final isToday = cellDate.year == today.year &&
                cellDate.month == today.month &&
                cellDate.day == today.day;

            return Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: isToday
                    ? const BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 13,
                      color: isToday ? Colors.white : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
