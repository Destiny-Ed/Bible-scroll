import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:myapp/features/discover/models/video_model.dart';

class LibraryViewModel extends ChangeNotifier {
  List<Video> _likedVideos = [];
  List<Video> _bookmarkedVideos = [];

  List<Video> get likedVideos => _likedVideos;
  List<Video> get bookmarkedVideos => _bookmarkedVideos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  LibraryViewModel() {
    _loadCachedLibrary();
    _fetchLibraryFromFirestore();
  }

  // Load from Hive (fast first paint)
  Future<void> _loadCachedLibrary() async {
    final likedBox = Hive.box<List<dynamic>>('likedVideos');
    final bookmarkedBox = Hive.box<List<dynamic>>('bookmarkedVideos');

    final cachedLiked = likedBox.get(_userId);
    final cachedBookmarked = bookmarkedBox.get(_userId);

    if (cachedLiked != null) {
      _likedVideos = cachedLiked.map((json) => Video.fromMap(json)).toList();
    }
    if (cachedBookmarked != null) {
      _bookmarkedVideos = cachedBookmarked
          .map((json) => Video.fromMap(json))
          .toList();
    }

    notifyListeners();
  }

  // Fetch from Firestore + cache
  Future<void> _fetchLibraryFromFirestore() async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      final likedIds = List<String>.from(userDoc.data()?['likedVideos'] ?? []);
      final bookmarkedIds = List<String>.from(
        userDoc.data()?['bookmarkedVideos'] ?? [],
      );

      // Fetch full video details
      final likedVideos = await _fetchVideosByIds(likedIds);
      final bookmarkedVideos = await _fetchVideosByIds(bookmarkedIds);

      _likedVideos = likedVideos;
      _bookmarkedVideos = bookmarkedVideos;

      // Cache them
      final likedBox = Hive.box<List<dynamic>>('likedVideos');
      final bookmarkedBox = Hive.box<List<dynamic>>('bookmarkedVideos');

      await likedBox.put(_userId, likedVideos.map((v) => v.toMap()).toList());
      await bookmarkedBox.put(
        _userId,
        bookmarkedVideos.map((v) => v.toMap()).toList(),
      );
    } catch (e) {
      debugPrint('Library fetch error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Video>> _fetchVideosByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final futures = ids.map((id) async {
      final doc = await FirebaseFirestore.instance
          .collection('videos')
          .doc(id)
          .get();
      if (doc.exists) {
        return Video.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    });

    final results = await Future.wait(futures);
    return results.whereType<Video>().toList();
  }
}
