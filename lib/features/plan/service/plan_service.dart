import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/plan/view_model/reading_plan_view_model.dart';

class PlanService {
  static const bool useDummyData =
      true; // ← Change to false when ready for Firebase

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  Future<void> saveUserReadingPlan(ReadingPlanViewModel vm) async {
    if (useDummyData) {
      log('=== DUMMY MODE: Plan would be saved ===');
      log('User ID: $_userId');
      log('Goal: ${vm.selectedGoal}');
      log('Daily minutes: ${vm.dailyTimeMinutes.round()}');
      log('Duration days: ${vm.planDurationDays}');
      log('Topics: ${vm.selectedTopics.join(", ")}');
      log('Timestamp: ${DateTime.now()}');
      return;
    }

    try {
      await _firestore.collection('users').doc(_userId).set({
        'readingPlan': {
          'goal': vm.selectedGoal,
          'dailyMinutes': vm.dailyTimeMinutes.round(),
          'durationDays': vm.planDurationDays,
          'topics': vm.selectedTopics.toList(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'progress': {'currentDay': 1, 'completedDays': 0, 'streak': 0},
        },
      }, SetOptions(merge: true));

      log('Reading plan saved successfully');
    } catch (e) {
      log('Error saving plan: $e');
      rethrow;
    }
  }

  // Future method you can call later in DailyReadingPlanScreen
  Future<Map<String, dynamic>?> getUserReadingPlan() async {
    if (useDummyData) {
      return {
        'goal': 'Find Peace & Comfort',
        'dailyMinutes': 20,
        'durationDays': 30,
        'topics': ['Psalms', 'Faith', 'Prayer'],
        'progress': {'currentDay': 6, 'completedDays': 5, 'streak': 5},
        'planName': '30 Days of Peace: A Visual Journey',
      };
    }

    final doc = await _firestore.collection('users').doc(_userId).get();
    return doc.data()?['readingPlan'] as Map<String, dynamic>?;
  }
}
