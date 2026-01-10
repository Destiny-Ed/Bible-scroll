// lib/features/plan/viewmodels/reading_plan_viewmodel.dart
import 'package:flutter/material.dart';

class ReadingPlanViewModel extends ChangeNotifier {
  // Goal Selection
  String? selectedGoal;
  bool get hasGoal => selectedGoal != null;

  // Commitment
  double dailyTimeMinutes = 15.0;
  int planDurationDays = 30;

  String get paceDescription {
    if (dailyTimeMinutes <= 15) return 'Light reading';
    if (dailyTimeMinutes <= 30) return 'Moderate pace';
    return 'Deep dive';
  }

  String get commitmentSummary =>
      '$paceDescription • ${planDurationDays == 365 ? '1 year' : '$planDurationDays days'} plan';

  // Personalization
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

  // Navigation / Flow control
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

  void selectGoal(String goal) {
    selectedGoal = goal;
    notifyListeners();
  }

  void updateDailyTime(double minutes) {
    dailyTimeMinutes = minutes;
    notifyListeners();
  }

  void updateDuration(int days) {
    planDurationDays = days;
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

  // Called when user presses "Finish" / "Generate My Plan"
  Future<void> generatePlan() async {
    // Here we would normally call the service to save to Firebase
    // For now we just simulate
    await Future.delayed(
      const Duration(milliseconds: 1200),
    ); // fake network delay

    // You can add real service call later:
    // await PlanService().saveUserReadingPlan(this);
  }

  // Summary text shown on last page
  String get onboardingSummary {
    return '''
Goal: ${selectedGoal ?? "Not selected"}
Daily time: ${dailyTimeMinutes.round()} minutes
Plan length: ${planDurationDays == 365 ? '1 year' : '$planDurationDays days'}
Topics of interest: ${selectedTopics.isEmpty ? "None selected" : selectedTopics.join(", ")}
    '''
        .trim();
  }
}
