import 'package:flutter/material.dart';
import 'package:myapp/features/discover/models/video_model.dart';

class FeedViewModel with ChangeNotifier {
  final List<Video> _videos = [
    Video(
      id: '1',
      chapterTitle: 'Genesis 1: The Creation',
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      description: 'In the beginning God created the heavens and the earth.',
      likes: 120,
      comments: 34,
      chapter: 'Genesis 1',
      thumbnailUrl: '',
      uploader: '',
      avatarUrl: '',
      topic: '',
      bookmarks: 30,
      commentsList: [],
    ),
    Video(
      id: '2',
      chapterTitle: 'Exodus 20: The Ten Commandments',
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
      description:
          'I am the LORD your God, who brought you out of Egypt, out of the land of slavery.',
      likes: 250,
      comments: 68,
      chapter: 'Exodus 20',
      thumbnailUrl: '',
      uploader: '',
      avatarUrl: '',
      topic: '',
      bookmarks: 30,
      commentsList: [],
    ),
    Video(
      id: '3',
      chapterTitle: 'Psalm 23: The Lord is My Shepherd',
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
      description: 'The LORD is my shepherd; I shall not want.',
      likes: 500,
      comments: 120,
      chapter: 'Psalm 23',
      thumbnailUrl: '',
      uploader: '',
      avatarUrl: '',
      topic: '',
      bookmarks: 30,
      commentsList: [],
    ),
  ];

  List<Video> get videos => _videos;

  void likeVideo(String videoId) {
    // Implement like functionality
    notifyListeners();
  }

  void bookmarkVideo(String videoId) {
    // Implement bookmark functionality
    notifyListeners();
  }
}
