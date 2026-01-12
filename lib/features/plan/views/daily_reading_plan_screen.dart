import 'package:flutter/material.dart';
import 'package:myapp/features/common/services/notification_services.dart';
import 'package:myapp/features/plan/view_model/daily_reading_plan_view.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/bible_reading/views/chapter_detail_screen.dart'; // ← Your chapter reader
// import 'package:myapp/features/video_player/video_player_screen.dart'; // ← If you have dedicated video player

class DailyReadingPlanScreen extends StatelessWidget {
  const DailyReadingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DailyReadingPlanViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (vm.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 24),
                  Text(vm.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: vm.refresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (vm.hasNoPlan) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_rounded, size: 80, color: Colors.grey),
                  const SizedBox(height: 24),
                  const Text(
                    'No reading plan found',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/plan-onboarding'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Your Plan'),
                  ),
                ],
              ),
            ),
          );
        }

        final planName = vm.planName;
        final totalDays = vm.totalDays;
        final completedDays = vm.completedDays;
        final streak = vm.streak;
        final progress = vm.getProgress;

        // Example: today's readings (in real app, generate from currentDay + topics)
        final todaysReadings = vm.todaysReading;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text(
              'My Journey',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: RefreshIndicator(
            onRefresh: vm.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildPlanOverview(
                      context,
                      planName,
                      streak,
                      completedDays,
                      totalDays,
                      progress,
                    ),
                    const SizedBox(height: 30),
                    _buildTodaysReading(context, todaysReadings),
                    const SizedBox(height: 40),
                    _buildContinueButton(context, todaysReadings),
                    const SizedBox(height: 40),
                    _buildMotivationCard(context, streak),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Plan Overview Card ──────────────────────────────────────────────────────
  Widget _buildPlanOverview(
    BuildContext context,
    String planName,
    int streak,
    int completedDays,
    int totalDays,
    double progress,
  ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$totalDays-DAY JOURNEY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            planName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(
                context,
                '$streak',
                'Day Streak',
                Icons.local_fire_department,
              ),
              _buildStatColumn(
                context,
                '$completedDays',
                'Days Completed',
                Icons.check_circle,
              ),
              _buildStatColumn(
                context,
                '${(progress * 100).toStringAsFixed(0)}%',
                'Progress',
                Icons.percent,
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(primary),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // ── Today's Reading List ───────────────────────────────────────────────────
  Widget _buildTodaysReading(
    BuildContext context,
    List<Map<String, dynamic>> readings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Reading",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (readings.any((r) => !(r['completed'] ?? false)))
              TextButton(
                onPressed: () {
                  // Optional: Mark all as read (or navigate to first unread)
                },
                child: const Text('Mark All'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ...readings.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildReadingItem(
            context,
            item['title'],
            item['subtitle'],
            item['completed'] ?? false,
            onTap: () {
              // Navigate to the chapter/video reading screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterDetailScreen(
                    chapterTitle: item['title'],
                    // Pass chapter reference, videoUrl, etc. as needed
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildReadingItem(
    BuildContext context,
    String title,
    String subtitle,
    bool isCompleted, {
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isCompleted
          ? theme.colorScheme.primaryContainer.withOpacity(0.6)
          : theme.colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        onTap: onTap, // ← Now navigates!
        leading: Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? theme.colorScheme.primary : Colors.grey.shade400,
          size: 32,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.grey,
        ),
      ),
    );
  }

  // ── Continue Button (jumps to first unread item) ────────────────────────────
  Widget _buildContinueButton(
    BuildContext context,
    List<Map<String, dynamic>> readings,
  ) {
    final unread = readings.where((r) => !(r['completed'] ?? false)).toList();

    if (unread.isEmpty) {
      return const SizedBox.shrink(); // All done today
    }

    return FilledButton.icon(
      onPressed: () async {
        // Find first unread and navigate
        final firstUnread = unread.first;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChapterDetailScreen(
              chapterTitle: firstUnread['title'],
              // Add chapter/video reference as needed
            ),
          ),
        );
      },
      icon: const Icon(Icons.play_arrow_rounded),
      label: Text(
        unread.length > 1
            ? 'Continue Reading (${unread.length} left)'
            : 'Continue Reading',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildMotivationCard(BuildContext context, int streak) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.15),
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Keep Going!',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            streak == 0
                ? 'Start your streak today!'
                : streak == 1
                ? 'Great first day! Keep going!'
                : streak < 7
                ? 'You’re on fire! $streak-day streak!'
                : 'Incredible! $streak days strong — God is proud!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
