import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:hive_ce/hive.dart';
import 'package:myapp/features/discover/models/video_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final List<Video> dummyVideos = [
  Video(
    id: '1',
    chapterTitle: 'Genesis 1: The Creation',
    videoUrl:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    description: 'In the beginning God created the heavens and the earth.',
    likesCount: 120,
    commentsCount: 34,
    chapter: 'Genesis 1',
    thumbnailUrl: '',
    uploader: '',
    avatarUrl: '',
    topic: '',
    bookmarksCount: 30,
    commentsList: [],
  ),
  Video(
    id: '2',
    chapterTitle: 'Exodus 20: The Ten Commandments',
    videoUrl:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
    description:
        'I am the LORD your God, who brought you out of Egypt, out of the land of slavery.',
    likesCount: 250,
    commentsCount: 68,
    chapter: 'Exodus 20',
    thumbnailUrl: '',
    uploader: '',
    avatarUrl: '',
    topic: '',
    bookmarksCount: 30,
    commentsList: [],
  ),
  Video(
    id: '3',
    chapterTitle: 'Psalm 23: The Lord is My Shepherd',
    videoUrl:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
    description: 'The LORD is my shepherd; I shall not want.',
    likesCount: 500,
    commentsCount: 120,
    chapter: 'Psalm 23',
    thumbnailUrl: '',
    uploader: '',
    avatarUrl: '',
    topic: '',
    bookmarksCount: 30,
    commentsList: [],
  ),
];

class FeedViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  List<Video> _videos = [];
  List<Video> get videos => _videos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  DocumentSnapshot? _lastDocument;

  FeedViewModel() {
    _loadCachedFeed();
    fetchVideos(reset: true);
  }

  // Load from Hive cache first (instant UI)
  Future<void> _loadCachedFeed() async {
    final box = Hive.box<List<dynamic>>('feedVideos');
    final cached = box.get('currentFeed');

    if (cached != null && cached.isNotEmpty) {
      try {
        _videos = cached.map((json) => Video.fromMap(json)).toList();
        notifyListeners();
      } catch (e) {
        debugPrint('Cache parse error: $e');
      }
    }
  }

  // Save current feed to Hive
  Future<void> _cacheFeed() async {
    final box = Hive.box<List<dynamic>>('feedVideos');
    final jsonList = _videos.map((v) => v.toMap()).toList();
    await box.put('currentFeed', jsonList);
  }

  Future<void> fetchVideos({bool reset = false}) async {
    _videos = dummyVideos;
    notifyListeners();
    return;
    if (_isLoading || (!_hasMore && !reset)) return;

    if (_videos.isEmpty) {
      _isLoading = true;
    }

    if (reset) {
      _videos = [];
      _lastDocument = null;
      _hasMore = true;
    }
    notifyListeners();

    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection('videos')
          .orderBy('createdAt', descending: true)
          .limit(10);

      log("Query::: ${query}");

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();

      log(snapshot.toString());

      if (snapshot.docs.isEmpty) {
        _hasMore = false;
      } else {
        _lastDocument = snapshot.docs.last;

        final List<Video> newVideos = [];

        for (final doc in snapshot.docs) {
          final data = doc.data();
          bool isLiked = false;
          bool isBookmarked = false;

          if (_currentUserId != null) {
            final likeSnap = await _firestore
                .collection('videos')
                .doc(doc.id)
                .collection('likes')
                .doc(_currentUserId)
                .get();
            isLiked = likeSnap.exists;

            final bookmarkSnap = await _firestore
                .collection('videos')
                .doc(doc.id)
                .collection('bookmarks')
                .doc(_currentUserId)
                .get();
            isBookmarked = bookmarkSnap.exists;
          }

          newVideos.add(
            Video.fromMap(
              {...data, 'id': doc.id},
              isLiked: isLiked,
              isBookmarked: isBookmarked,
            ),
          );
        }

        if (reset) {
          _videos = newVideos;
        } else {
          _videos.addAll(newVideos);
        }

        // Cache the fresh data
        await _cacheFeed();
      }
    } catch (e) {
      log(e.toString());
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Increment view count when video becomes visible
  Future<void> incrementView(String videoId) async {
    await _firestore.collection('videos').doc(videoId).update({
      'viewsCount': FieldValue.increment(1),
    });
  }

  Future<void> toggleLike(String videoId) async {
    if (_currentUserId == null) return;

    final videoIndex = _videos.indexWhere((v) => v.id == videoId);
    if (videoIndex == -1) return;

    final current = _videos[videoIndex];
    final newLiked = !current.isLiked;

    // Optimistic UI update
    _videos[videoIndex] = Video(
      id: current.id,
      chapterTitle: current.chapterTitle,
      chapter: current.chapter,
      description: current.description,
      videoUrl: current.videoUrl,
      thumbnailUrl: current.thumbnailUrl,
      uploader: current.uploader,
      avatarUrl: current.avatarUrl,
      topic: current.topic,
      likesCount: current.likesCount + (newLiked ? 1 : -1),
      bookmarksCount: current.bookmarksCount,
      commentsCount: current.commentsCount,
      viewsCount: current.viewsCount,
      commentsList: current.commentsList,
      isLiked: newLiked,
      isBookmarked: current.isBookmarked,
    );
    notifyListeners();

    try {
      await _firestore.runTransaction((transaction) async {
        final videoRef = _firestore.collection('videos').doc(videoId);
        final likeRef = videoRef.collection('likes').doc(_currentUserId);

        final userRef = _firestore.collection('users').doc(_currentUserId);

        final videoSnap = await transaction.get(videoRef);
        int newCount = videoSnap.data()?['likesCount'] ?? 0;

        if (newLiked) {
          transaction.set(likeRef, {'timestamp': FieldValue.serverTimestamp()});
          newCount++;
          transaction.update(userRef, {
            'likedVideos': FieldValue.arrayUnion([videoId]),
          });
        } else {
          transaction.delete(likeRef);
          newCount = newCount > 0 ? newCount - 1 : 0;
          transaction.update(userRef, {
            'likedVideos': FieldValue.arrayRemove([videoId]),
          });
        }

        transaction.update(videoRef, {'likesCount': newCount});
      });
    } catch (e) {
      // Rollback optimistic update on error
      fetchVideos(reset: true);
    }
  }

  Future<void> toggleBookmark(String videoId) async {
    if (_currentUserId == null) return;

    final videoIndex = _videos.indexWhere((v) => v.id == videoId);
    if (videoIndex == -1) return;

    final current = _videos[videoIndex];
    final newBookmarked = !current.isBookmarked;

    // Optimistic UI update
    _videos[videoIndex] = Video(
      id: current.id,
      chapterTitle: current.chapterTitle,
      chapter: current.chapter,
      description: current.description,
      videoUrl: current.videoUrl,
      thumbnailUrl: current.thumbnailUrl,
      uploader: current.uploader,
      avatarUrl: current.avatarUrl,
      topic: current.topic,
      bookmarksCount: current.bookmarksCount + (newBookmarked ? 1 : -1),
      likesCount: current.likesCount,
      commentsCount: current.commentsCount,
      viewsCount: current.viewsCount,
      commentsList: current.commentsList,
      isLiked: current.isLiked,
      isBookmarked: newBookmarked,
    );
    notifyListeners();

    try {
      await _firestore.runTransaction((transaction) async {
        final videoRef = _firestore.collection('videos').doc(videoId);
        final likeRef = videoRef.collection('bookmarks').doc(_currentUserId);

        final userRef = _firestore.collection('profile').doc(_currentUserId);

        final videoSnap = await transaction.get(videoRef);
        int newCount = videoSnap.data()?['bookmarksCount'] ?? 0;

        if (newBookmarked) {
          transaction.set(likeRef, {'timestamp': FieldValue.serverTimestamp()});
          newCount++;
          transaction.update(userRef, {
            'bookmarkedVideos': FieldValue.arrayUnion([videoId]),
          });
        } else {
          transaction.delete(likeRef);
          newCount = newCount > 0 ? newCount - 1 : 0;
          transaction.update(userRef, {
            'bookmarkedVideos': FieldValue.arrayRemove([videoId]),
          });
        }

        transaction.update(videoRef, {'bookmarksCount': newCount});
      });
    } catch (e) {
      // Rollback optimistic update on error
      fetchVideos(reset: true);
    }
  }

  Future<void> addComment(String videoId, String text) async {
    if (_currentUserId == null || text.trim().isEmpty) return;

    final commentRef = _firestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .doc();

    await commentRef.set({
      'comment': text,
      'commenter': _currentUserId,
      'avatarUrl': '', //TODO: fetch from user profile
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('videos').doc(videoId).update({
      'commentsCount': FieldValue.increment(1),
    });

    notifyListeners();
  }

  Future<void> incrementShare(String videoId) async {
    await _firestore.collection('videos').doc(videoId).update({
      'sharesCount': FieldValue.increment(1),
    });
    notifyListeners();
  }

  // Future<void> downloadVideoWithWatermark(
  //   String videoUrl,
  //   String videoId,
  // ) async {
  //   try {
  //     // 1. Request storage permission
  //     if (!await _requestStoragePermission()) return;

  //     // 2. Download video
  //     final tempDir = await getTemporaryDirectory();
  //     final tempPath = '${tempDir.path}/temp_$videoId.mp4';

  //     await Dio().download(
  //       videoUrl,
  //       tempPath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           final progress = (received / total * 100).toStringAsFixed(0);
  //           // Update UI progress if needed (e.g. via notifier)
  //           print('Download progress: $progress%');
  //         }
  //       },
  //     );

  //     // 3. Add watermark using ffmpeg
  //     final finalPath = '${tempDir.path}/watermarked_$videoId.mp4';
  //     final logoPath = 'assets/logo.png'; // your app logo

  //     final session = await FFmpegKit.execute(
  //       '-i $tempPath -i $logoPath -filter_complex "overlay=W-w-20:H-h-20" -codec:a copy $finalPath',
  //     );

  //     final returnCode = await session.getReturnCode();
  //     if (ReturnCode.isSuccess(returnCode)) {
  //       //Save to gallery
  //       final success = await Gal.putVideo(finalPath);
  //       // if (success) {
  //       //   print('Video saved to gallery with watermark!');
  //       // } else {
  //       //   print('Failed to save to gallery');
  //       // }
  //     } else {
  //       print('FFmpeg error: ${await session.getLogs()}');
  //     }

  //     // Clean up temp files
  //     File(tempPath).deleteSync();
  //     File(finalPath).deleteSync();
  //   } catch (e) {
  //     print('Download failed: $e');
  //   }
  // }

  // Future<bool> _requestStoragePermission() async {
  //   final status = await Permission.storage.request();
  //   return status.isGranted;
  // }
}
