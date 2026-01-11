import 'package:flutter/material.dart';
import 'package:myapp/features/discover/models/video_model.dart';
import 'package:myapp/features/home/viewmodels/feed_view_model.dart';
import 'package:provider/provider.dart';

class ManageVideoScreen extends StatelessWidget {
  const ManageVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = Provider.of<FeedViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Videos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showVideoDialog(context, feedViewModel),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: feedViewModel.videos.length,
        itemBuilder: (context, index) {
          final video = feedViewModel.videos[index];
          return ListTile(
            title: Text(video.title),
            subtitle: Text(video.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      _showVideoDialog(context, feedViewModel, video: video),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => feedViewModel.deleteVideo(video.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showVideoDialog(BuildContext context, FeedViewModel feedViewModel,
      {Video? video}) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController(text: video?.title ?? '');
    final _descriptionController =
        TextEditingController(text: video?.description ?? '');
    final _videoUrlController = TextEditingController(text: video?.videoUrl ?? '');
    final _topicController = TextEditingController(text: video?.topic ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(video == null ? 'Add Video' : 'Edit Video'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                TextFormField(
                  controller: _videoUrlController,
                  decoration: const InputDecoration(labelText: 'Video URL'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a video URL' : null,
                ),
                TextFormField(
                  controller: _topicController,
                  decoration: const InputDecoration(labelText: 'Topic'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a topic' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newVideo = Video(
                    id: video?.id ?? DateTime.now().toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    videoUrl: _videoUrlController.text,
                    topic: _topicController.text,
                    uploader: video?.uploader ?? 'Admin',
                    avatarUrl: video?.avatarUrl ?? '',
                    likes: video?.likes ?? 0,
                    thumbnailUrl: '',
                  );

                  if (video == null) {
                    feedViewModel.addVideo(newVideo);
                  } else {
                    feedViewModel.updateVideo(newVideo);
                  }

                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
