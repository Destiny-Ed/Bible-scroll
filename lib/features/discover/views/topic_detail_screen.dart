import 'package:flutter/material.dart';
import 'package:myapp/features/discover/viewmodels/discover_viewmodel.dart';
import 'package:myapp/features/discover/views/video_detail_screen.dart';
import 'package:provider/provider.dart';

class TopicDetailScreen extends StatelessWidget {
  final String topicName;

  const TopicDetailScreen({super.key, required this.topicName});

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverViewModel>(
      builder: (context, vm, child) {
        final topicVideos = vm.videos.where((v) => v.topic == topicName).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(topicName),
            elevation: 0,
          ),
          body: topicVideos.isEmpty
              ? const Center(child: Text('No videos in this topic yet'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: topicVideos.length,
                  itemBuilder: (context, index) {
                    final video = topicVideos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          vm.markVideoAsWatched(video.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoDetailScreen(video: video),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: Image.network(
                                video.thumbnailUrl,
                                width: 140,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      video.chapterTitle,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      video.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey[700],
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.favorite, size: 16, color: Colors.red),
                                        const SizedBox(width: 4),
                                        Text('${video.likesCount}'),
                                        const SizedBox(width: 16),
                                        Icon(Icons.comment, size: 16),
                                        const SizedBox(width: 4),
                                        Text('${video.commentsCount}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}