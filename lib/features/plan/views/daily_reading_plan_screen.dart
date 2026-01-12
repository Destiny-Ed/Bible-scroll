import 'package:flutter/material.dart';
import 'package:myapp/features/plan/view_model/daily_reading_plan_view.dart';
import 'package:provider/provider.dart';

class DailyReadingPlanScreen extends StatelessWidget {
  const DailyReadingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DailyReadingPlanViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
    
        if (vm.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 80, color: Colors.red),
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
                  const Text('No reading plan found', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/plan-onboarding'),
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
        final todaysReadings = vm.todaysReading;
    
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text('My Journey', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    _buildPlanOverview(context, planName, streak, completedDays, totalDays, progress),
                    const SizedBox(height: 30),
                    _buildTodaysReading(context, todaysReadings, vm),
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

  Widget _buildPlanOverview(BuildContext context, String planName, int streak, int completedDays, int totalDays, double progress) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$totalDays-DAY JOURNEY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary)),
          const SizedBox(height: 8),
          Text(planName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(context,'$streak', 'Day Streak', Icons.local_fire_department),
              _buildStatColumn(context,'$completedDays', 'Days Completed', Icons.check_circle),
              _buildStatColumn(context,'${(progress * 100).toStringAsFixed(0)}%', 'Progress', Icons.percent),
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

  Widget _buildStatColumn(BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTodaysReading(BuildContext context, List<Map<String, dynamic>> readings, DailyReadingPlanViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Reading", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...readings.map((item) {
          final isCompleted = item['completed'] ?? false;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isCompleted ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surface,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              leading: Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                size: 32,
              ),
              title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(item['subtitle'], style: const TextStyle(color: Colors.grey)),
              trailing: isCompleted
                  ? const Icon(Icons.check, color: Colors.green, size: 28)
                  : IconButton(
                      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                      onPressed: vm.isMarkingComplete
                          ? null
                          : () async {
                              await vm.markChapterAsRead(item['title']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Marked "${item['title']}" as read!')),
                              );
                            },
                      tooltip: 'Mark as Read',
                    ),
              onTap: () {
                // Navigate to chapter/video reader
                // Navigator.push(context, MaterialPageRoute(builder: (_) => ChapterDetailScreen(chapterTitle: item['title'])));
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMotivationCard(BuildContext context, int streak) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary.withOpacity(0.15), Theme.of(context).colorScheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text('Keep Going!', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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