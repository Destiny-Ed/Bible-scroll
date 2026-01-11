import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import '../models/book_model.dart';
import '../services/bible_service.dart';

class BibleReadingViewModel extends ChangeNotifier {
  final BibleService _bibleService;

  // Reading state
  List<Verse> _verses = [];
  List<Verse> get verses => _verses;

  bool _isLoadingVerses = false;
  bool get isLoadingVerses => _isLoadingVerses;

  String? _error;
  String? get error => _error;

  // Video state
  VideoPlayerController? _videoController;
  VideoPlayerController? get videoController => _videoController;

  bool _isVideoInitialized = false;
  bool get isVideoInitialized => _isVideoInitialized;

  BibleReadingViewModel(this._bibleService);

  Future<void> fetchVerses(String bookName, int chapter) async {
    _isLoadingVerses = true;
    _error = null;
    notifyListeners();

    try {
      _verses = await _bibleService.fetchAndCacheVerses(bookName, chapter);
    } catch (e) {
      _error = _humanizeError(e);
      debugPrint('Fetch error: $e');
    } finally {
      _isLoadingVerses = false;
      notifyListeners();
    }
  }

  Future<void> initializeVideo(String videoUrl) async {
    if (_videoController != null) {
      await _videoController!.dispose();
    }

    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    try {
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _isVideoInitialized = true;
    } catch (e) {
      _isVideoInitialized = false;
      debugPrint('Video init failed: $e');
    }
    notifyListeners();
  }

  String _humanizeError(dynamic error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('socket') ||
        msg.contains('network') ||
        msg.contains('connection')) {
      return "No internet connection. Please check your network and try again.";
    }
    if (msg.contains('404') || msg.contains('not found')) {
      return "This chapter could not be found. It may not exist in the selected translation.";
    }
    return "Failed to load the chapter. Please try again later.";
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
