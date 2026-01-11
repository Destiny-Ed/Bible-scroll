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
            'https://images.unsplash.com/photo-1524672322242-4365e8424a68?q=80&w=2070&auto=format&fit=crop',
        uploader: 'Bible Stories',
        avatarUrl:
            'https://yt3.ggpht.com/ytc/AKedOLQUD_a-4_f-h_sJt-t_s_s-A_u_u-U_U_U_U=s900-c-k-c0x00ffffff-no-rj',
        topic: 'Faith',
        likes: 1200,
        chapter: '',
        bookmarks: 30,
        comments: 10,
        commentsList: [],
      ),
      Video(
        id: '2',
        chapterTitle: 'The Sermon on the Mount',
        description: 'A deep dive into Jesus\' teachings.',
        videoUrl: 'https://example.com/video2.mp4',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1509377452285-05451e0b5712?q=80&w=2070&auto=format&fit=crop',
        uploader: 'The Gospel Project',
        avatarUrl:
            'https://yt3.ggpht.com/ytc/AKedOLQUD_a-4_f-h_sJt-t_s_s-A_u_u-U_U_U_U=s900-c-k-c0x00ffffff-no-rj',
        topic: 'Wisdom',
        likes: 2500,
        chapter: '',
        bookmarks: 45,
        comments: 23,
        commentsList: [],
      ),
      Video(
        id: '3',
        chapterTitle: 'The Book of Revelation Explained',
        description: 'Understanding the end times.',
        videoUrl: 'https://example.com/video3.mp4',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1518065202573-8d31139a3f29?q=80&w=2070&auto=format&fit=crop',
        uploader: 'Prophecy Unveiled',
        avatarUrl:
            'https://yt3.ggpht.com/ytc/AKedOLQUD_a-4_f-h_sJt-t_s_s-A_u_u-U_U_U_U=s900-c-k-c0x00ffffff-no-rj',
        topic: 'Hope',
        likes: 5000,
        chapter: '',
        bookmarks: 5,
        comments: 6,
        commentsList: [],
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
