// lib/features/plan/viewmodels/reading_plan_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:myapp/features/plan/service/plan_service.dart';

class ReadingPlanViewModel extends ChangeNotifier {
  // ── Goal Selection ────────────────────────────────────────────────────────
  String? selectedGoal;
  bool get hasGoal => selectedGoal != null && selectedGoal!.isNotEmpty;

  // ── Commitment ─────────────────────────────────────────────────────────────
  double dailyTimeMinutes = 15.0;
  int planDurationDays = 30;

  String get paceDescription {
    if (dailyTimeMinutes <= 15) return 'Light reading';
    if (dailyTimeMinutes <= 30) return 'Moderate pace';
    return 'Deep dive';
  }

  String get commitmentSummary =>
      '$paceDescription • ${planDurationDays == 365 ? '1 year' : '$planDurationDays days'} plan';

  // ── Personalization ────────────────────────────────────────────────────────
  final List<String> availableTopics = [
    'Parables',
    'Wisdom',
    'Prophecy',
    'Miracles',
    'History',
    'Gospels',
    'Psalms',
    'Leadership',
    'Love',
    'Faith',
    'Prayer',
  ];

  final Set<String> selectedTopics = {};

  bool get hasTopics => selectedTopics.isNotEmpty;

  // ── Navigation / Flow control ──────────────────────────────────────────────
  int currentPage = 0;

  void updatePage(int page) {
    currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < 2) {
      currentPage++;
      notifyListeners();
    }
  }

  // ── State Management ───────────────────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _planGeneratedSuccessfully = false;
  bool get planGeneratedSuccessfully => _planGeneratedSuccessfully;

  // ── Actions ────────────────────────────────────────────────────────────────
  void selectGoal(String goal) {
    selectedGoal = goal;
    notifyListeners();
  }

  void updateDailyTime(double minutes) {
    dailyTimeMinutes = minutes.clamp(5.0, 60.0);
    notifyListeners();
  }

  void updateDuration(int days) {
    planDurationDays = days.clamp(7, 365);
    notifyListeners();
  }

  void toggleTopic(String topic, bool selected) {
    if (selected) {
      selectedTopics.add(topic);
    } else {
      selectedTopics.remove(topic);
    }
    notifyListeners();
  }

  Future<void> generatePlan() async {
    _isLoading = true;
    _error = null;
    _planGeneratedSuccessfully = false;
    notifyListeners();

    try {
      await PlanService().saveReadingPlan(this);
      _planGeneratedSuccessfully = true;
    } catch (e) {
      _error =
          e.toString().contains('network') ||
              e.toString().contains('connection')
          ? 'No internet connection. Please try again.'
          : 'Failed to create plan. Please try again.';
      debugPrint('Plan generation error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset form (optional, call when user wants to start over)
  void reset() {
    selectedGoal = null;
    dailyTimeMinutes = 15.0;
    planDurationDays = 30;
    selectedTopics.clear();
    currentPage = 0;
    _error = null;
    _planGeneratedSuccessfully = false;
    notifyListeners();
  }

  // Summary text shown on last page
  String get onboardingSummary {
    return '''
Goal: ${selectedGoal ?? "Not selected"}
Daily time: ${dailyTimeMinutes.round()} minutes (${paceDescription.toLowerCase()})
Plan length: ${planDurationDays == 365 ? '1 year' : '$planDurationDays days'}
Topics of interest: ${selectedTopics.isEmpty ? "None selected" : selectedTopics.join(", ")}
    '''
        .trim();
  }

  // Helper: Get a dynamic plan name (used in success screen too)
  String get generatedPlanName {
    if (selectedTopics.isEmpty) return 'Personalized Bible Journey';
    if (selectedTopics.any(
      (t) =>
          t.toLowerCase().contains('peace') ||
          t.toLowerCase().contains('comfort'),
    )) {
      return '$planDurationDays-Day Journey of Peace';
    }
    if (selectedTopics.contains('Wisdom')) return 'Wisdom Through the Word';
    return '$planDurationDays-Day ${selectedGoal ?? "Spiritual"} Adventure';
  }
}
