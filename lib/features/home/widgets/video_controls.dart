
import 'package:flutter/material.dart';
import 'package:myapp/features/discover/models/video_model.dart';

class VideoControls extends StatelessWidget {
  final Video video;

  const VideoControls({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildVideoInfo(context),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildVideoInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.chapterTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            video.verseText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(context, icon: Icons.favorite, label: video.likes.toString()),
        const SizedBox(height: 20),
        _buildActionButton(context, icon: Icons.comment, label: video.comments.toString()),
        const SizedBox(height: 20),
        _buildActionButton(context, icon: Icons.bookmark, label: 'Save'),
        const SizedBox(height: 20),
        _buildActionButton(context, icon: Icons.share, label: 'Share'),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}
