import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/bible_service.dart';

class ReadingViewModel extends ChangeNotifier {
  final BibleService _bibleService = BibleService();
  VideoPlayerController? _videoPlayerController;
  bool _isPlayerInitialized = false;

  String _verses = '';
  bool _isLoading = false;

  String get verses => _verses;
  bool get isLoading => _isLoading;
  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  bool get isPlayerInitialized => _isPlayerInitialized;

  Future<void> fetchVerses(String bookName, int chapter) async {
    _isLoading = true;
    notifyListeners();
    try {
      _verses = await _bibleService.fetchAndCacheVerses(bookName, chapter);
    } catch (e) {
      // Handle error
      _verses = 'Error fetching verses';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initializePlayer(String videoUrl) async {
    _videoPlayerController = VideoPlayerController.network(videoUrl);
    await _videoPlayerController!.initialize();
    _isPlayerInitialized = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
