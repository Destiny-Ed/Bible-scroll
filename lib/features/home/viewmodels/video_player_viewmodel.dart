import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  final Map<String, CachedVideoPlayerPlus> _player = {};

  CachedVideoPlayerPlus? getController(String videoUrl) {
    return _player[videoUrl];
  }

  Future<CachedVideoPlayerPlus> createController(String videoUrl) async {
    final playerController = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(videoUrl),
    );
    _player[videoUrl] = playerController;
    await playerController.initialize();
    playerController.controller.setLooping(true);
    notifyListeners();
    return playerController;
  }

  void disposeController(String videoUrl) {
    _player[videoUrl]?.dispose();
    _player.remove(videoUrl);
  }

  @override
  void dispose() {
    for (final controller in _player.values) {
      controller.dispose();
    }
    _player.clear();
    super.dispose();
  }
}
