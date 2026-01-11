import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/discover/models/video_model.dart';

class AdminViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Video> _videos = [];
  List<Video> get videos => _videos;

  Map<String, List<Video>> _discoverGroups = {};
  Map<String, List<Video>> get discoverGroups => _discoverGroups;

  List<Comments> _comments = [];
  List<Comments> get comments => _comments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    await Future.wait([fetchVideos(), fetchDiscoverContent(), fetchComments()]);
  }

  Future<void> refreshAll() async {
    await Future.wait([fetchVideos(), fetchDiscoverContent(), fetchComments()]);
  }

  Future<void> fetchVideos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('videos')
          .orderBy('createdAt', descending: true)
          .get();

      _videos = snapshot.docs.map((doc) {
        final data = doc.data();
        return Video.fromMap({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      print(e);
      _errorMessage = 'Failed to load videos: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDiscoverContent() async {
    try {
      final groups = <String, List<Video>>{};

      for (final video in _videos) {
        final topic = (video.topic.isEmpty ? 'Uncategorized' : video.topic);
        groups.putIfAbsent(topic, () => []).add(video);
      }

      _discoverGroups = groups;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to group discover content';
    }
  }

  Future<void> fetchComments() async {
    try {
      final snapshot = await _firestore
          .collectionGroup('comments')
          .orderBy('createdAt', descending: true)
          .limit(200)
          .get();

      _comments = snapshot.docs.map((doc) {
        final data = doc.data();
        return Comments.fromMap({
          ...data,
          'id': doc.id,
          'videoId': doc.reference.parent.parent!.id,
        });
      }).toList();

      notifyListeners();
    } catch (e) {
      print(e);

      _errorMessage = 'Failed to load comments: $e';
    }
  }

  Future<void> addVideo(Video video) async {
    _isLoading = true;
    notifyListeners();

    try {
      final ref = await _firestore.collection('videos').add({
        ...video.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      final newVideo = Video.fromMap({...video.toMap(), 'id': ref.id});

      _videos.insert(0, newVideo);
      await fetchDiscoverContent(); // Refresh groups
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add video: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateVideo(Video updatedVideo) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore
          .collection('videos')
          .doc(updatedVideo.id)
          .update(updatedVideo.toMap());

      final index = _videos.indexWhere((v) => v.id == updatedVideo.id);
      if (index != -1) {
        _videos[index] = updatedVideo;
        await fetchDiscoverContent(); // Refresh groups
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update video: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteVideo(String videoId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('videos').doc(videoId).delete();

      _videos.removeWhere((v) => v.id == videoId);
      await fetchDiscoverContent(); // Refresh groups
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete video: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Comment moderation (approve/reject)
  Future<void> moderateComment(
    String videoId,
    String commentId,
    bool approved,
  ) async {
    try {
      await _firestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId)
          .update({
            'approved': approved,
            'moderatedAt': FieldValue.serverTimestamp(),
          });

      final index = _comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        _comments[index] = Comments.fromMap({
          ..._comments[index].toMap(),
          'approved': approved,
        });
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to moderate comment: $e';
    }
  }

  Future<void> deleteComment(String videoId, String commentId) async {
    try {
      await _firestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId)
          .delete();

      _comments.removeWhere((c) => c.id == commentId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete comment: $e';
    }
  }
}
