import 'package:flutter/material.dart';
import 'package:myapp/features/discover/models/video_model.dart';
import 'package:myapp/features/home/viewmodels/video_player_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends StatefulWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  VideoPlayerController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeController();
  }

  Future<void> _initializeController() async {
    final viewModel = Provider.of<VideoPlayerViewModel>(context, listen: false);
    final controller = await viewModel.createController(widget.video.videoUrl);
    if (mounted) {
      setState(() {
        _controller = controller;
      });
      _controller?.play();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
        _buildVideoControls(),
        _buildVideoDetails(),
        _buildSideBar(),
      ],
    );
  }

  Widget _buildVideoControls() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
        });
      },
      child: Center(
        child: AnimatedOpacity(
          opacity: _controller!.value.isPlaying ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 60.0),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoDetails() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.video.avatarUrl),
                ),
                const SizedBox(width: 8.0),
                Text(
                  widget.video.uploader,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.video.chapterTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              widget.video.description,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8.0),
            VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.white,
                bufferedColor: Colors.white54,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideBar() {
    return Positioned(
      right: 16.0,
      bottom: 90.0, // Adjust this value as needed
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white, size: 30.0),
            onPressed: () {},
          ),
          Text(
            '${(widget.video.likes / 1000).toStringAsFixed(1)}k',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16.0),
          IconButton(
            icon: const Icon(Icons.comment, color: Colors.white, size: 30.0),
            onPressed: () {},
          ),
          const SizedBox(height: 16.0),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white, size: 30.0),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
