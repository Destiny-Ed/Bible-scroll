import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myapp/features/discover/models/video_model.dart';
import 'package:myapp/features/discover/views/chapter_detail_screen.dart';
import 'package:myapp/features/discover/widgets/comments_modal_sheet.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoCard extends StatefulWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late final CachedVideoPlayerPlus _player;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(widget.video.videoUrl),
    );

    _player.initialize().then((_) {
      setState(() => _isInitialized = true);
      // _player.controller.play();
      _player.controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    _player.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.video.id),
      onVisibilityChanged: (info) {
        if (!_player.controller.value.isInitialized) return;
        if (info.visibleFraction > 0.6) {
          // Play if >60% visible
          _player.controller.play();
        } else {
          _player.controller.pause();
        }
        _player.controller.pause();
      },

      child: GestureDetector(
        onTap: () {
          if (_player.controller.value.isPlaying) {
            _player.controller.pause();
          } else {
            _player.controller.play();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            _isInitialized
                ? AspectRatio(
                    aspectRatio: _player.controller.value.aspectRatio,
                    child: VideoPlayer(_player.controller),
                  )
                : const Center(child: CircularProgressIndicator.adaptive()),
            _buildGradientOverlay(),
            _buildVideoOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withAlpha(76),
            Colors.transparent,
            Colors.black.withAlpha(127),
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
            const SizedBox(width: 16),
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
        GestureDetector(
          onTap: () {
            showMaterialModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => const CommentsModalSheet(),
            );
          },
          child: _buildIconButton(
            Icons.comment,
            widget.video.comments.toString(),
          ),
        ),
        const SizedBox(height: 20),
        _buildIconButton(Icons.bookmark, ''),
        const SizedBox(height: 20),

        _buildIconButton(Icons.share, ''),
        const SizedBox(height: 20),
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
