import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/feed_view_model.dart';
import '../widgets/video_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentPage = 0;
  final PreloadPageController _pageController = PreloadPageController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final feedViewModel = context.watch<FeedViewModel>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'For You',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(width: 8),
            // const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.live_tv, color: Colors.white),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: PreloadPageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: feedViewModel.videos.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        preloadPagesCount: 5,
        itemBuilder: (context, index) {
          final video = feedViewModel.videos[index];
          final isCurrentVisible = index == _currentPage;
          return VideoCard(video: video, isCurrentVisible: isCurrentVisible);
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
