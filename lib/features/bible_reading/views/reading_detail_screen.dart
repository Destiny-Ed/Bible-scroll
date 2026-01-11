import 'package:flutter/material.dart';
import 'package:myapp/features/bible_reading/models/book_model.dart';
import 'package:myapp/features/bible_reading/viewmodels/reading_view_model.dart';
import 'package:myapp/shared/widgets/error_widget.dart';
import 'package:provider/provider.dart';
import 'package:myapp/shared/widgets/video_player_widget.dart';

class ReadingDetailScreen extends StatefulWidget {
  final Book book;
  final int chapter;

  const ReadingDetailScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  State<ReadingDetailScreen> createState() => _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends State<ReadingDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch verses immediately
    final viewModel = context.read<BibleReadingViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchVerses(widget.book.name, widget.chapter);
    });

    // Optional: Initialize video here if you have a dynamic URL
    // viewModel.initializeVideo('https://your-video-url.com/video.mp4');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.book.name} ${widget.chapter}'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Reading'),
              Tab(text: 'Video'),
            ],
          ),
        ),
        body: TabBarView(children: [_buildReadingTab(), _buildVideoTab()]),
      ),
    );
  }

  Widget _buildReadingTab() {
    return Consumer<BibleReadingViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoadingVerses) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          final isOffline =
              viewModel.error!.contains('Failed to load') ||
              viewModel.error!.contains('SocketException') ||
              viewModel.error!.contains('Network');

          return ErrorOrOfflineWidget(
            isOffline: isOffline,
            errorMessage: viewModel.error,
            onRetry: !isOffline
                ? () => viewModel.fetchVerses(widget.book.name, widget.chapter)
                : null,
          );
        }

        if (viewModel.verses.isEmpty) {
          return const Center(child: Text('No verses available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: viewModel.verses.length,
          itemBuilder: (context, index) {
            final verse = viewModel.verses[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '${verse.verse}. ${verse.text}',
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVideoTab() {
    return Consumer<BibleReadingViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.isVideoInitialized) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading video...'),
              ],
            ),
          );
        }

        return VideoPlayerWidget(
          videoUrl: viewModel.videoController!.dataSource,
          // You can pass additional props like autoPlay, looping, etc.
        );
      },
    );
  }
}
