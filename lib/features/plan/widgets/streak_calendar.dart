import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Add this new widget inside DailyReadingPlanScreen or as a separate file
class StreakCalendar extends StatelessWidget {
  final int currentStreak;
  final DateTime? lastReadDate;
  final int maxStreak; // Optional: show longest streak if tracked

  const StreakCalendar({
    super.key,
    required this.currentStreak,
    this.lastReadDate,
    required this.maxStreak,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;

    // Calculate which days have been read (simplified: last 30 days)
    final readDays = _getReadDays(lastReadDate, currentStreak);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Streak Calendar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (maxStreak != null && maxStreak > currentStreak)
              Text(
                'Longest: $maxStreak days',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Month name + year
        Text(
          DateFormat('MMMM yyyy').format(today),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),

        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map((day) => SizedBox(
                    width: 40,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),

        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: daysInMonth + _getOffsetDays(firstDayOfMonth),
          itemBuilder: (context, index) {
            // Offset empty days at start of month
            if (index < _getOffsetDays(firstDayOfMonth)) {
              return const SizedBox.shrink();
            }

            final dayNumber = index - _getOffsetDays(firstDayOfMonth) + 1;
            final date = DateTime(today.year, today.month, dayNumber);

            final isToday = date.day == today.day && date.month == today.month;
            final wasRead = readDays.contains(date);

            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: wasRead
                    ? Colors.green.withOpacity(0.8)
                    : isToday
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                        : null,
                border: isToday ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
              ),
              child: Center(
                child: Text(
                  '$dayNumber',
                  style: TextStyle(
                    color: wasRead ? Colors.white : null,
                    fontWeight: isToday ? FontWeight.bold : null,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Streak stats summary
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStreakStat(
              context,
              '$currentStreak',
              'Current Streak',
              Icons.local_fire_department,
              Colors.orange,
            ),
            const SizedBox(width: 40),
            if (maxStreak != null)
              _buildStreakStat(
                context,
                '$maxStreak',
                'Longest Streak',
                Icons.emoji_events,
                Colors.amber,
              ),
          ],
        ),
      ],
    );
  }

  int _getOffsetDays(DateTime firstDay) {
    // Sunday = 0, Monday = 1, ..., Saturday = 6
    return firstDay.weekday % 7;
  }

  // Simplified: assume user read every day of current streak
  // In real app: fetch actual read dates from Firestore
  List<DateTime> _getReadDays(DateTime? lastRead, int streak) {
    if (lastRead == null || streak == 0) return [];

    final days = <DateTime>[];
    var current = lastRead;

    for (int i = 0; i < streak; i++) {
      days.add(current);
      current = current.subtract(const Duration(days: 1));
    }

    return days;
  }

  Widget _buildStreakStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}