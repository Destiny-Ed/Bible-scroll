import 'dart:math';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:particles_flutter/shapes.dart';
import 'package:video_player/video_player.dart';
import 'package:particles_flutter/engine.dart';
import '../models/video_model.dart';
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
          _buildParticleEffect(),
          _buildGradientOverlay(),
          _buildVideoOverlay(),
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildTopSection(),
          const SizedBox(height: 16),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
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

  Widget _buildBottomSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [_buildLeftSection(), _buildRightSection()],
    );
  }

  Widget _buildLeftSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          // backgroundImage: NetworkImage(widget.video.creator.profileImageUrl),
        ),
        const SizedBox(width: 12),
        Text(
          '@username', // Replace with actual username
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Follow',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
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
