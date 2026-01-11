import 'package:flutter/material.dart';
import 'package:myapp/features/discover/models/video_model.dart';
import 'package:myapp/features/library/viewmodels/library_viewmodel.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Library'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Liked Videos'),
              Tab(text: 'Bookmarked Videos'),
            ],
          ),
        ),
        body: Consumer<LibraryViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              children: [
                _buildVideoList(vm.likedVideos, 'No liked videos yet'),
                _buildVideoList(
                  vm.bookmarkedVideos,
                  'No bookmarked videos yet',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoList(List<Video> videos, String emptyText) {
    if (videos.isEmpty) {
      return Center(child: Text(emptyText));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              // Navigate to video detail / player
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Image.network(
                    video.thumbnailUrl.isNotEmpty
                        ? video.thumbnailUrl
                        : 'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8',
                    width: 120,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.chapterTitle,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          video.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }
}
