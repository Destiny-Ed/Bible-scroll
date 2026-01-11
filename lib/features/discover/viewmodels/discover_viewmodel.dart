import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:myapp/features/discover/models/topic_model.dart';
import 'package:myapp/features/discover/models/video_model.dart';

class DiscoverViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Topic> _topics = [];
  List<Topic> get topics => _topics;

  List<Video> _videos = [];
  List<Video> get videos => _videos;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Set<String> _watchedVideoIds = {}; // Persistent across sessions
  Set<String> get watchedVideoIds => _watchedVideoIds;

  DiscoverViewModel() {
    _fetchData();
  }

  Future<void> _fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch videos from Firestore
      final videoSnapshot = await _firestore
          .collection('videos')
          .orderBy('createdAt', descending: true)
          .limit(50) // Adjust as needed
          .get();

      if (videoSnapshot.docs.isEmpty) {
        // Fallback to dummy if Firestore is empty
        _loadDummyData();
      } else {
        _videos = videoSnapshot.docs.map((doc) {
          final data = doc.data();
          return Video.fromMap({...data, 'id': doc.id});
        }).toList();

        // Build unique topics from videos
        final topicSet = _videos
            .map((v) => v.topic)
            .where((t) => t.isNotEmpty)
            .toSet();
        _topics = topicSet
            .map((name) => Topic(name: name, icon: Icons.psychology))
            .toList();
      }
    } catch (e) {
      _errorMessage = 'Failed to load discover content: $e';
      debugPrint('Discover fetch error: $e');

      // Fallback to dummy on error too
      _loadDummyData();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _loadDummyData() {
    _topics = [
      Topic(name: 'Faith', icon: Icons.favorite),
      Topic(name: 'Love', icon: Icons.favorite_border),
      Topic(name: 'Hope', icon: Icons.lightbulb),
      Topic(name: 'Prayer', icon: Icons.hail),
      Topic(name: 'Wisdom', icon: Icons.psychology),
      Topic(name: 'Grace', icon: Icons.star),
    ];

    _videos = [
      Video(
        id: '1',
        chapterTitle: 'The Story of David',
        description: 'A short animated summary of faith in action.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8',
        uploader: 'Bible Stories',
        avatarUrl:
            'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61',
        topic: 'Faith',
        likesCount: 1200,
        chapter: '1 Samuel 17',
        bookmarksCount: 30,
        commentsCount: 10,
        commentsList: [],
      ),
      Video(
        id: '2',
        chapterTitle: 'The Sermon on the Mount',
        description: 'Jesus\' teachings on love and compassion.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1506744038136-46273869b3fb',
        uploader: 'The Gospel Project',
        avatarUrl:
            'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61',
        topic: 'Love',
        likesCount: 2500,
        chapter: 'Matthew 5-7',
        bookmarksCount: 45,
        commentsCount: 23,
        commentsList: [],
      ),
      Video(
        id: '3',
        chapterTitle: 'The Book of Revelation Explained',
        description: 'Understanding the end times.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8',
        uploader: 'Prophecy Unveiled',
        avatarUrl:
            'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61',
        topic: 'Hope',
        likesCount: 5000,
        chapter: 'Revelation 1-22',
        bookmarksCount: 5,
        commentsCount: 6,
        commentsList: [],
      ),
      // Add more dummy videos as needed
    ];
  }

  Future<void> markVideoAsWatched(String videoId) async {
    if (_watchedVideoIds.contains(videoId)) return;

    _watchedVideoIds.add(videoId);

    // Persist to Hive
    try {
      final box = Hive.box('discover');
      await box.put('watchedIds', _watchedVideoIds.toList());
    } catch (e) {
      debugPrint('Failed to save watched state: $e');
    }

    notifyListeners();
  }

  /// Returns recommended "Up Next" videos:
  /// 1. Prioritizes unwatched videos from the same topic
  /// 2. Then unwatched from other topics
  /// 3. Excludes the current video
  List<Video> getUpNextVideos(String currentVideoId, String currentTopic) {
    final unwatched = _videos
        .where(
          (v) => v.id != currentVideoId && !_watchedVideoIds.contains(v.id),
        )
        .toList();

    // Same topic first
    final sameTopic = unwatched.where((v) => v.topic == currentTopic).toList();

    // Then others
    final others = unwatched.where((v) => v.topic != currentTopic).toList();

    return [...sameTopic, ...others];
  }

  // Optional: Refresh method for pull-to-refresh
  Future<void> refresh() async {
    await _fetchData();
  }
}
