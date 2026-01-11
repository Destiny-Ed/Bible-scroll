import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  // In a real app, you would use a video player controller here.
  // For this example, we'll just simulate the video player.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.videoUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
            ),
          ),
        ),
      ),
    );
  }
}
