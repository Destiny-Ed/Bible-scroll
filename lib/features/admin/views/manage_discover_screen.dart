import 'package:flutter/material.dart';
import 'package:myapp/features/discover/models/video_model.dart';
import 'package:myapp/features/home/viewmodels/feed_view_model.dart';
import 'package:provider/provider.dart';

class ManageDiscoverScreen extends StatelessWidget {
  const ManageDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = Provider.of<FeedViewModel>(context);
    final topics = feedViewModel.videos.map((v) => v.topic).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Discover Content'),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          final videos = feedViewModel.videos
              .where((video) => video.topic == topic)
              .toList();

          return ExpansionTile(
            title: Text(topic),
            children: videos
                .map((video) => ListTile(
                      title: Text(video.chapterTitle),
                      subtitle: Text(video.description),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
