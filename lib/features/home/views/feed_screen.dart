import 'package:flutter/material.dart';
import 'package:myapp/features/home/viewmodels/feed_view_model.dart';
import 'package:myapp/features/home/widgets/video_card.dart';
import 'package:myapp/shared/widgets/error_widget.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentPage = 0;
  final PreloadPageController _pageController = PreloadPageController();
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedViewModel>().fetchVideos(reset: true);
    });

    // Listen for scroll near bottom
    _scrollController.addListener(() {
      final vm = context.read<FeedViewModel>();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent -
                  300 && // 300px threshold
          !vm.isLoading &&
          vm.hasMore) {
        vm.fetchVideos(); // load next page
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
          ],
        ),
      ),
      body: Consumer<FeedViewModel>(
        builder: (context, feedViewModel, _) {
          return Builder(
            builder: (context) {
              if (feedViewModel.isLoading && feedViewModel.videos.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (feedViewModel.error != null && feedViewModel.videos.isEmpty) {
                return ErrorOrOfflineWidget(
                  errorMessage: feedViewModel.error,
                  onRetry: () => feedViewModel.fetchVideos(reset: true),
                );
              }

              if (feedViewModel.videos.isEmpty) {
                return const Center(child: Text('No videos available yet'));
              }

              return Stack(
                children: [
                  PreloadPageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    preloadPagesCount: 5,
                    itemCount:
                        feedViewModel.videos.length +
                        (feedViewModel.hasMore ? 1 : 0),
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      if (index >= 0 && index < feedViewModel.videos.length) {
                        feedViewModel.incrementView(
                          feedViewModel.videos[index].id,
                        );
                      }
                    },
                    itemBuilder: (context, index) {
                      // Show loading footer when reaching end
                      if (index == feedViewModel.videos.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final video = feedViewModel.videos[index];
                      final isCurrentVisible = index == _currentPage;

                      return VideoCard(
                        video: video,
                        isCurrentVisible: isCurrentVisible,
                      );
                    },
                  ),

                  // Floating loading indicator when fetching more
                  if (feedViewModel.isLoading &&
                      feedViewModel.videos.isNotEmpty)
                    const Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
