import 'package:flutter/foundation.dart';
import 'package:myapp/features/discover/models/topic_model.dart';
import 'package:myapp/features/discover/models/video_model.dart';

class DiscoverViewModel extends ChangeNotifier {
  List<Topic> _topics = [];
  List<Topic> get topics => _topics;

  List<Video> _videos = [];
  List<Video> get videos => _videos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DiscoverViewModel() {
    _fetchData();
  }

  Future<void> _fetchData() async {
    _isLoading = true;
    notifyListeners();

    // Mock data fetching
    await Future.delayed(const Duration(seconds: 1));

    _topics = [
      Topic(name: 'Faith'),
      Topic(name: 'Love'),
      Topic(name: 'Hope'),
      Topic(name: 'Prayer'),
      Topic(name: 'Wisdom'),
      Topic(name: 'Grace'),
    ];

    _videos = [
      Video(
        id: '1',
        chapterTitle: 'The Story of David',
        description: 'A short animated summary.',
        videoUrl: 'https://example.com/video1.mp4',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?q=80&w=2070&auto=format&fit=crop',
        uploader: 'Bible Stories',
        avatarUrl:
            'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop',
        topic: 'Faith',
        likesCount: 1200,
        chapter: '',
        bookmarksCount: 30,
        commentsCount: 10,
        commentsList: [],
      ),
      Video(
        id: '2',
        chapterTitle: 'The Sermon on the Mount',
        description: 'A deep dive into Jesus\' teachings.',
        videoUrl: 'https://example.com/video2.mp4',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?q=80&w=2070&auto=format&fit=crop',
        uploader: 'The Gospel Project',
        avatarUrl:
            'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop',
        topic: 'Wisdom',
        likesCount: 2500,
        chapter: '',
        bookmarksCount: 45,
        commentsCount: 23,
        commentsList: [],
      ),
      Video(
        id: '3',
        chapterTitle: 'The Book of Revelation Explained',
        description: 'Understanding the end times.',
        videoUrl: 'https://example.com/video3.mp4',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?q=80&w=2070&auto=format&fit=crop',
        uploader: 'Prophecy Unveiled',
        avatarUrl:
            'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop',
        topic: 'Hope',
        likesCount: 5000,
        chapter: '',
        bookmarksCount: 5,
        commentsCount: 6,
        commentsList: [],
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
