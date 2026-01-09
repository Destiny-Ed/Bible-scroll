import 'package:flutter/material.dart';
import 'package:myapp/features/home/widgets/video_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const VideoCard(videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-a-girl-looking-at-the-camera-in-the-middle-of-a-beautiful-field-43402-large.mp4');
        },
      ),
    );
  }
}
