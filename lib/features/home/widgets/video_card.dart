import 'dart:math';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myapp/features/discover/models/video_model.dart';
import 'package:myapp/features/discover/views/chapter_detail_screen.dart';
import 'package:myapp/features/common/widgets/comments_modal_sheet.dart';
import 'package:myapp/features/home/viewmodels/feed_view_model.dart';
import 'package:myapp/features/home/viewmodels/video_player_viewmodel.dart';
import 'package:particles_flutter/engine.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoCard extends StatefulWidget {
  final Video video;
  final bool isCurrentVisible;

  const VideoCard({
    super.key,
    required this.video,
    required this.isCurrentVisible,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard>
    with AutomaticKeepAliveClientMixin {
  CachedVideoPlayerPlus? _playerController;

  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    if (_isInitialized) return;
    if (_playerController != null) return;

    final viewModel = Provider.of<VideoPlayerViewModel>(context, listen: false);
    final controller = await viewModel.createController(widget.video.videoUrl);

    if (mounted) {
      setState(() {
        _playerController = controller;
        _isInitialized = true;
      });

      // Do NOT auto-play here!
      controller.controller.setLooping(true);
      controller.controller.setVolume(1.0);
    }
  }

  @override
  void didUpdateWidget(covariant VideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // React to visibility change from parent
    if (widget.isCurrentVisible != oldWidget.isCurrentVisible) {
      _handleVisibilityChange();
    }
  }

  void _handleVisibilityChange() {
    if (_playerController == null || !_isInitialized) return;

    if (widget.isCurrentVisible) {
      _playerController!.controller.play();
    } else {
      _playerController!.controller.pause();
      // Optional: reset position if you want
      // _playerController!.controller.seekTo(Duration.zero);
    }
  }

  //   _buildIconButton(
  //   Icons.download,
  //   'Download',
  //   onTap: () => vm.downloadVideoWithWatermark(widget.video.videoUrl, widget.video.id),
  // ),

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return VisibilityDetector(
      key: Key(widget.video.videoUrl),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.6) {
          _playerController?.controller.play();
        } else {
          _playerController?.controller.pause();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: _playerController!.controller.value.aspectRatio,
            child: VideoPlayer(_playerController!.controller),
          ),
          // _buildParticleEffect(),
          _buildGradientOverlay(),
          _buildVideoOverlay(),
          _buildVideoControls(),
        ],
      ),
    );
  }

  Widget _buildParticleEffect() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Particles(
      particles: createParticles(), // List of particles
      height: screenHeight,
      width: screenWidth,
    );
  }

  List<Particle> createParticles() {
    var rng = Random();
    List<Particle> particles = [];

    // Circle particle example
    for (int i = 0; i < 32; i++) {
      particles.add(
        CircularParticle(
          color: Colors.white.withOpacity(0.6),
          radius: rng.nextDouble() * 20,
          velocity: Offset(
            rng.nextDouble() * 200 * 20,
            rng.nextDouble() * 200 * 20,
          ),
        ),
      );
    }
    return particles;
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.transparent,
            Colors.black.withOpacity(0.5),
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
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTopSection(),
            // const SizedBox(height: 16),
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
        crossAxisAlignment: CrossAxisAlignment.end,
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
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
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
            widget.video.description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8.0),
          VideoProgressIndicator(
            _playerController!.controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.white,
              bufferedColor: Colors.white54,
              backgroundColor: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildIconButton(
          Icons.favorite,
          widget.video.likesCount.toString(),
          onTap: () {
            final vm = context.read<FeedViewModel>();
            vm.toggleLike(widget.video.id);
          },
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            showMaterialModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) =>
                  CommentsModalSheet(videoId: widget.video.id),
            );
          },
          child: _buildIconButton(
            Icons.comment,
            widget.video.commentsCount.toString(),
          ),
        ),
        const SizedBox(height: 20),

        _buildIconButton(
          Icons.bookmark,
          widget.video.bookmarksCount.toString(),
        ),
        const SizedBox(height: 20),
        _buildIconButton(Icons.share, '34'),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
      ),
    );
  }

  Widget _buildVideoControls() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _playerController!.controller.value.isPlaying
              ? _playerController!.controller.pause()
              : _playerController!.controller.play();
        });
      },
      child: Center(
        child: AnimatedOpacity(
          opacity: _playerController!.controller.value.isPlaying ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 60.0,
            ),
          ),
        ),
      ),
    );
  }
}
