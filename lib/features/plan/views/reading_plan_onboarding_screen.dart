import 'package:flutter/material.dart';
import 'package:myapp/features/plan/view_model/reading_plan_view_model.dart';
import 'package:myapp/features/plan/views/plan_generation_success_screen.dart';
import 'package:provider/provider.dart';

class ReadingPlanOnboardingScreen extends StatefulWidget {
  const ReadingPlanOnboardingScreen({super.key});

  @override
  State<ReadingPlanOnboardingScreen> createState() =>
      _ReadingPlanOnboardingScreenState();
}

class _ReadingPlanOnboardingScreenState
    extends State<ReadingPlanOnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReadingPlanViewModel>();
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: vm.updatePage,
              children: [
                // Step 1: Goal Selection
                _buildStep(
                  title: "What's your main goal?",
                  subtitle:
                      "Select the spiritual focus that matters most to you",
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        ...[
                          'Deepen My Faith',
                          'Find Peace & Comfort',
                          'Understand the Bible Better',
                          'Wisdom, Guidance & Protection',
                        ].map((goal) => _buildGoalOption(vm, goal)),
                      ],
                    ),
                  ),
                ),

                // Step 2: Commitment (Time & Duration)
                _buildStep(
                  title: "How much time can you commit?",
                  subtitle: "Customize your pace and plan length",
                  child: _buildCommitmentContent(vm),
                ),

                // Step 3: Topics + Summary
                _buildStep(
                  title: "What interests you most?",
                  subtitle: "Select topics you'd love to explore",
                  child: _buildPersonalizationContent(vm, context),
                ),
              ],
            ),

            // Bottom Controls (Dots + Continue)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [surface.withOpacity(0.1), surface],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: vm.currentPage == i ? 24 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: vm.currentPage == i
                                ? primary
                                : primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Continue / Finish Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: vm.currentPage == 0
                            ? (vm.hasGoal ? () => _animateToPage(vm, 1) : null)
                            : vm.currentPage == 1
                            ? () => _animateToPage(vm, 2)
                            : () async {
                                await vm.generatePlan();
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PlanGenerationSuccessScreen(
                                            goal:
                                                vm.selectedGoal ??
                                                "Not selected",
                                            dailyMinutes: vm.dailyTimeMinutes
                                                .round(),
                                            durationDays: vm.planDurationDays,
                                            topics: vm.selectedTopics.toList(),
                                          ),
                                    ),
                                  );
                                }
                              },
                        icon: vm.currentPage == 2
                            ? const Icon(Icons.celebration)
                            : const SizedBox.shrink(),
                        label: Text(
                          vm.currentPage == 2
                              ? 'Finish & Generate Plan'
                              : 'Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _animateToPage(ReadingPlanViewModel vm, int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildStep({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),
        child,
      ],
    );
  }

  Widget _buildGoalOption(ReadingPlanViewModel vm, String title) {
    final isSelected = vm.selectedGoal == title;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      onTap: () => vm.selectGoal(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withOpacity(0.15)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: primary.withOpacity(0.2), blurRadius: 12)]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              _getGoalIcon(title),
              size: 40,
              color: isSelected ? primary : Colors.grey.shade600,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primary : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getGoalSubtitle(title),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGoalSubtitle(String goal) {
    switch (goal) {
      case 'Deepen My Faith':
        return 'Strengthen your spiritual foundation';
      case 'Find Peace & Comfort':
        return 'Find hope and tranquility in Scripture';
      case 'Understand the Bible Better':
        return 'Grow in knowledge of God’s Word';
      default:
        return 'Seek daily direction and divine covering';
    }
  }

  IconData _getGoalIcon(String goal) {
    switch (goal) {
      case 'Deepen My Faith':
        return Icons.lightbulb_outline;
      case 'Find Peace & Comfort':
        return Icons.self_improvement;
      case 'Understand the Bible Better':
        return Icons.menu_book;
      default:
        return Icons.shield_outlined;
    }
  }

  Widget _buildCommitmentContent(ReadingPlanViewModel vm) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${vm.dailyTimeMinutes.round()} minutes / day',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vm.commitmentSummary,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 40),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            ),
            child: Slider(
              value: vm.dailyTimeMinutes,
              min: 5,
              max: 60,
              divisions: 11,
              activeColor: primary,
              inactiveColor: primary.withOpacity(0.2),
              onChanged: vm.updateDailyTime,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [7, 30, 90, 180, 365].map((days) {
              final isSelected = vm.planDurationDays == days;
              return ChoiceChip(
                label: Text(days == 365 ? '1 Year' : '$days Days'),
                selected: isSelected,
                onSelected: (_) => vm.updateDuration(days),
                selectedColor: primary,
                backgroundColor: theme.colorScheme.surface,
                labelStyle: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizationContent(
    ReadingPlanViewModel vm,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: vm.availableTopics.map((topic) {
              final selected = vm.selectedTopics.contains(topic);
              return FilterChip(
                label: Text(topic),
                selected: selected,
                onSelected: (val) => vm.toggleTopic(topic, val),
                selectedColor: primary,
                backgroundColor: theme.colorScheme.surface,
                checkmarkColor: theme.colorScheme.onPrimary,
                labelStyle: TextStyle(
                  color: selected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
