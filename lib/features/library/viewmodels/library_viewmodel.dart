import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/discover/models/video_model.dart';

class LibraryViewModel extends ChangeNotifier {
  List<Video> _likedVideos = [];
  List<Video> _bookmarkedVideos = [];

  List<Video> get likedVideos => _likedVideos;
  List<Video> get bookmarkedVideos => _bookmarkedVideos;

  Future<void> loadLibrary(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .get();

    final likedIds = List<String>.from(userDoc.data()?['likedVideos'] ?? []);
    final bookmarkedIds = List<String>.from(
      userDoc.data()?['bookmarkedVideos'] ?? [],
    );

    // Fetch full video docs
    final likedFutures = likedIds.map(
      (id) => FirebaseFirestore.instance.collection('videos').doc(id).get(),
    );
    final bookmarkedFutures = bookmarkedIds.map(
      (id) => FirebaseFirestore.instance.collection('videos').doc(id).get(),
    );

    final likedSnapshots = await Future.wait(likedFutures);
    final bookmarkedSnapshots = await Future.wait(bookmarkedFutures);

    _likedVideos = likedSnapshots
        .where((snap) => snap.exists)
        .map((snap) => Video.fromMap({...snap.data()!, 'id': snap.id}))
        .toList();

    _bookmarkedVideos = bookmarkedSnapshots
        .where((snap) => snap.exists)
        .map((snap) => Video.fromMap({...snap.data()!, 'id': snap.id}))
        .toList();

    notifyListeners();
  }
}
