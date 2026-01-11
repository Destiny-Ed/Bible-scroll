import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  final Map<String, VideoPlayerController> _controllers = {};

  VideoPlayerController? getController(String videoUrl) {
    return _controllers[videoUrl];
  }

  Future<VideoPlayerController> createController(String videoUrl) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    _controllers[videoUrl] = controller;
    await controller.initialize();
    controller.setLooping(true);
    notifyListeners();
    return controller;
  }

  void disposeController(String videoUrl) {
    _controllers[videoUrl]?.dispose();
    _controllers.remove(videoUrl);
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }
}
