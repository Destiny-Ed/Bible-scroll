
import 'package:flutter/material.dart';
import 'package:myapp/features/bible_reading/services/reading_detail_service.dart';
import 'package:myapp/features/bible_reading/viewmodels/reading_detail_viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:myapp/shared/widgets/video_player_widget.dart';

class ReadingDetailScreen extends StatelessWidget {
  final String book;
  final int chapter;

  const ReadingDetailScreen({super.key, required this.book, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReadingDetailViewModel(ReadingDetailService())..fetchVerses(book, chapter),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('$book $chapter'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Reading'),
                Tab(text: 'Video'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildReadingTab(),
              _buildVideoTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadingTab() {
    return Consumer<ReadingDetailViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Center(child: Text('Error: ${viewModel.error}'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: viewModel.verses.length,
          itemBuilder: (context, index) {
            final verse = viewModel.verses[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('${verse.verse} ${verse.text}'),
            );
          },
        );
      },
    );
  }

  Widget _buildVideoTab() {
    // Replace with your actual video player
    return const Center(
      child: VideoPlayerWidget(videoUrl: 'https://www.youtube.com/watch?v=your_video_id'),
    );
  }
}
