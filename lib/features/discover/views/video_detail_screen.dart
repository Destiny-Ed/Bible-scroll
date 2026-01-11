import 'package:flutter/material.dart';
import 'package:myapp/features/discover/models/video_model.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:myapp/features/discover/viewmodels/discover_viewmodel.dart';

class VideoDetailScreen extends StatefulWidget {
  final Video video;

  const VideoDetailScreen({super.key, required this.video});

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.addListener(_checkVideoCompletion);
      });
  }

  void _checkVideoCompletion() {
    if (_controller.value.position >= _controller.value.duration - const Duration(seconds: 2)) {
      final vm = context.read<DiscoverViewModel>();
      vm.markVideoAsWatched(widget.video.id);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkVideoCompletion);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DiscoverViewModel>();
    final upNext = vm.getUpNextVideos(widget.video.id, widget.video.topic);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.chapterTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _controller.value.isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(_controller),
                        _controller.value.isPlaying
                            ? const SizedBox.shrink()
                            : IconButton(
                                icon: const Icon(Icons.play_circle_fill, size: 80, color: Colors.white70),
                                onPressed: () => _controller.play(),
                              ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),

            // Video Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.chapterTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.video.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      Chip(label: Text(widget.video.topic), backgroundColor: Colors.blue.shade100),
                      Chip(label: Text('${widget.video.likesCount} likes')),
                      Chip(label: Text('${widget.video.viewsCount} views')),
                    ],
                  ),
                ],
              ),
            ),

            // Up Next Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Up Next',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 12),

            if (upNext.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No more videos to watch in this series!'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: upNext.length,
                itemBuilder: (context, index) {
                  final nextVideo = upNext[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          nextVideo.thumbnailUrl,
                          width: 80,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(nextVideo.chapterTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(nextVideo.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.play_arrow_rounded),
                      onTap: () {
                        vm.markVideoAsWatched(widget.video.id); // Mark current as watched
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoDetailScreen(video: nextVideo),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}