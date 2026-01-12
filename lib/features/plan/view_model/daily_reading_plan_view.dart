// lib/features/plan/viewmodels/daily_reading_plan_viewmodel.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DailyReadingPlanViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  Map<String, dynamic>? _plan;
  Map<String, dynamic>? get plan => _plan;

  Map<String, dynamic>? _progress;
  Map<String, dynamic>? get progress => _progress;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _hasNoPlan = false;
  bool get hasNoPlan => _hasNoPlan;

  bool _isMarkingComplete = false;
  bool get isMarkingComplete => _isMarkingComplete;

  DailyReadingPlanViewModel() {
    _loadPlanAndProgress();
  }

  Future<void> _loadPlanAndProgress() async {
    _isLoading = true;
    _error = null;
    _hasNoPlan = false;
    notifyListeners();

    if (_userId == null) {
      _error = 'Please sign in to view your plan';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(_userId).get();

      if (!doc.exists || doc.data()?['readingPlan'] == null) {
        _hasNoPlan = true;
      } else {
        _plan = doc.data()?['readingPlan'] as Map<String, dynamic>?;
        _progress = doc.data()?['readingProgress'] as Map<String, dynamic>?;
      }
    } catch (e) {
      _error = 'Failed to load your plan: $e';
      debugPrint('Plan load error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Refresh (e.g. after marking complete)
  Future<void> refresh() async {
    await _loadPlanAndProgress();
  }

  Future<void> markChapterAsRead(String chapterTitle) async {
    if (_userId == null || _progress == null) return;

    _isMarkingComplete = true;
    notifyListeners();

    try {
      await _firestore.runTransaction((transaction) async {
        final userRef = _firestore.collection('users').doc(_userId);
        final snapshot = await transaction.get(userRef);

        final progress = snapshot.data()?['readingProgress'] ?? {};
        final lastRead = progress['lastReadDate'] as Timestamp?;
        final lastDate = lastRead?.toDate();
        final today = DateTime.now();

        int newStreak = progress['streak'] ?? 0;
        int newCompleted = (progress['completedDays'] ?? 0) + 1;
        int currentDay = (progress['currentDay'] ?? 1);

        // Streak logic
        if (lastDate == null) {
          newStreak = 1; // First read
        } else {
          final diffDays = today.difference(lastDate).inDays;
          if (diffDays == 0) {
            // Same day - don't increment streak, just update
          } else if (diffDays == 1) {
            newStreak++; // Consecutive
          } else {
            newStreak = 1; // Broken streak
          }
        }

        transaction.update(userRef, {
          'readingProgress': {
            'currentDay': currentDay,
            'completedDays': newCompleted,
            'lastReadDate': FieldValue.serverTimestamp(),
            'streak': newStreak,
            'chaptersRead': FieldValue.arrayUnion([chapterTitle]),
          },
        });
      });

      // Refresh UI after successful update
      await _loadPlanAndProgress();
    } catch (e) {
      _error = 'Failed to mark as read: $e';
      debugPrint('Mark read error: $e');
    }
  }

  // Generate dynamic plan name (fallback if not stored)
  String get planName {
    if (_plan == null) return 'Your Journey';
    return _plan!['planName'] ?? 'Personalized Bible Journey';
  }

  int get totalDays => _plan?['durationDays'] as int? ?? 30;
  int get completedDays => _progress?['completedDays'] as int? ?? 0;
  int get streak => _progress?['streak'] as int? ?? 0;
  double get getProgress => totalDays > 0 ? completedDays / totalDays : 0.0;

  // Example today's reading (you can generate dynamically based on currentDay)
  List<Map<String, dynamic>> get todaysReading {
    // Replace with real chapter generation logic later
    return [
      {
        'title': 'Genesis 1-2',
        'subtitle': 'The Creation Story',
        'completed': true,
      },
      {
        'title': 'John 1',
        'subtitle': 'The Word Became Flesh',
        'completed': false,
      },
      {
        'title': 'Psalms 23',
        'subtitle': 'The Lord is My Shepherd',
        'completed': false,
      },
    ];
  }
}
