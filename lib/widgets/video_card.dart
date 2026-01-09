import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:video_player/video_player.dart';
import '../models/video_model.dart';
import '../views/chapter_detail_screen.dart';
import '../views/video_player_screen.dart';
import 'comments_modal_sheet.dart';

class VideoCard extends StatefulWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
            _controller.setLooping(true);
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VideoPlayerScreen(videoUrl: widget.video.videoUrl),
          ),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const Center(child: CircularProgressIndicator()),
          _buildGradientOverlay(),
          _buildVideoOverlay(),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withAlpha(77),
            Colors.transparent,
            Colors.black.withAlpha(128),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 0.9],
        ),
      ),
    );
  }

  Widget _buildVideoOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTopSection(),
            _buildRightSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterDetailScreen(
                    chapterTitle: widget.video.chapterTitle,
                  ),
                ),
              );
            },
            child: Text(
              widget.video.chapterTitle,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                shadows: [
                  const Shadow(
                    blurRadius: 5,
                    color: Colors.black45,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.video.verseText,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildIconButton(Icons.favorite, widget.video.likes.toString()),
        const SizedBox(height: 20),
        _buildIconButton(Icons.bookmark, ''),
        const SizedBox(height: 20),
        _buildIconButton(Icons.share, ''),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => const CommentsModalSheet(),
            );
          },
          child: _buildIconButton(
            Icons.comment,
            widget.video.comments.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        if (text.isNotEmpty)
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
