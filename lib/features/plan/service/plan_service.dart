import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/plan/view_model/reading_plan_view_model.dart';

class PlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> saveReadingPlan(ReadingPlanViewModel vm) async {
    if (_userId == null) throw Exception('User not authenticated');

    final planData = {
      'goal': vm.selectedGoal ?? 'Not selected',
      'dailyMinutes': vm.dailyTimeMinutes.round(),
      'durationDays': vm.planDurationDays,
      'topics': vm.selectedTopics.toList(),
      'planName': _generatePlanName(vm),
      'startDate': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('users').doc(_userId).set({
      'readingPlan': planData,
      'readingProgress': {
        'currentDay': 1,
        'completedDays': 0,
        'lastReadDate': null,
        'streak': 0,
        'chaptersRead': [],
      },
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getReadingPlan() async {
    if (_userId == null) return null;

    final doc = await _firestore.collection('users').doc(_userId).get();
    return doc.data()?['readingPlan'] as Map<String, dynamic>?;
  }

  Future<Map<String, dynamic>?> getReadingProgress() async {
    if (_userId == null) return null;

    final doc = await _firestore.collection('users').doc(_userId).get();
    return doc.data()?['readingProgress'] as Map<String, dynamic>?;
  }

  /// Mark today's reading as complete & update streak
  Future<void> markTodayComplete(List<String> chaptersReadToday) async {
    if (_userId == null) return;

    final progressRef = _firestore.collection('users').doc(_userId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(progressRef);
      final progress = snapshot.data()?['readingProgress'] ?? {};

      final lastRead = progress['lastReadDate'] as Timestamp?;
      final lastDate = lastRead?.toDate();
      final today = DateTime.now();

      int newStreak = progress['streak'] ?? 0;

      // Streak logic
      if (lastDate == null) {
        newStreak = 1; // First day
      } else {
        final diffDays = today.difference(lastDate).inDays;
        if (diffDays == 1) {
          newStreak++; // Consecutive day
        } else if (diffDays > 1) {
          newStreak = 1; // Streak broken
        }
        // else same day → don't increment
      }

      transaction.update(progressRef, {
        'readingProgress': {
          'currentDay': (progress['currentDay'] ?? 0) + 1,
          'completedDays': FieldValue.increment(1),
          'lastReadDate': FieldValue.serverTimestamp(),
          'streak': newStreak,
          'chaptersRead': FieldValue.arrayUnion(chaptersReadToday),
        },
      });
    });
  }

  String _generatePlanName(ReadingPlanViewModel vm) {
    if (vm.selectedTopics.isEmpty) return 'Personalized Bible Journey';
    if (vm.selectedTopics.any(
      (t) => t.contains('Peace') || t.contains('Comfort'),
    )) {
      return '${vm.planDurationDays}-Day Journey of Peace';
    }
    return '${vm.planDurationDays}-Day ${vm.selectedGoal ?? "Spiritual"} Adventure';
  }
}
