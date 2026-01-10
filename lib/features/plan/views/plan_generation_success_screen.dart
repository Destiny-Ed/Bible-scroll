import 'package:flutter/material.dart';
import 'package:myapp/features/home/views/home_screen.dart';

class PlanGenerationSuccessScreen extends StatelessWidget {
  final String goal;
  final int dailyMinutes;
  final int durationDays;
  final List<String> topics;

  const PlanGenerationSuccessScreen({
    super.key,
    required this.goal,
    required this.dailyMinutes,
    required this.durationDays,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    final pace = dailyMinutes <= 15
        ? 'Light'
        : dailyMinutes <= 30
        ? 'Moderate'
        : 'Deep';

    final durationText = durationDays == 365 ? '1 Year' : '$durationDays Days';
    final topicsText = topics.isEmpty
        ? 'No specific topics selected'
        : topics.join(', ');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Success Icon / Header
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary.withOpacity(0.15),
                  ),
                  child: Icon(
                    Icons.celebration_rounded,
                    size: 44,
                    color: primary,
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Your Custom Plan is Ready!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'We\'ve created a personalized journey based on your answers',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 40),

                // Personalized Summary Card
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.12),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: Text(
                          '$durationText Personalized Journey',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryRow(
                              context,
                              icon: Icons.track_changes,
                              label: 'Your Goal',
                              value: goal,
                            ),
                            const Divider(height: 32),
                            _buildSummaryRow(
                              context,
                              icon: Icons.timer_outlined,
                              label: 'Daily Commitment',
                              value: '$dailyMinutes minutes ($pace pace)',
                            ),
                            const Divider(height: 32),
                            _buildSummaryRow(
                              context,
                              icon: Icons.calendar_today_outlined,
                              label: 'Plan Duration',
                              value: durationText,
                            ),
                            const Divider(height: 32),
                            _buildSummaryRow(
                              context,
                              icon: Icons.category_outlined,
                              label: 'Focus Topics',
                              value: topicsText,
                              isMultiLine: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Start Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: const Text(
                      'Start My Journey Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'You can adjust your plan anytime in Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isMultiLine = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiLine
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
