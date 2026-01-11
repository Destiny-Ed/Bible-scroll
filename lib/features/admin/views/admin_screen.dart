import 'package:flutter/material.dart';
import 'package:myapp/features/admin/dialog/video_mutation_dialog.dart';
import 'package:myapp/features/admin/views/tabs/comments_moderation_tab.dart';
import 'package:myapp/features/admin/views/tabs/discover_management_tab.dart';
import 'package:myapp/features/admin/views/tabs/video_management_tab.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/admin/viewmodels/admin_viewmodel.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminViewModel()..init(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh All',
              onPressed: () {
                context.read<AdminViewModel>().refreshAll();
              },
            ),
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(icon: Icon(Icons.video_library_rounded), text: 'Videos'),
                  Tab(icon: Icon(Icons.explore_rounded), text: 'Discover'),
                  Tab(icon: Icon(Icons.comment_rounded), text: 'Comments'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: const [
                    VideoManagementTab(),
                    DiscoverManagementTab(),
                    CommentModerationTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showVideoFormDialog(
            context,
            existingVideo: null,
            viewModel: context.read<AdminViewModel>(),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Add Video'),
        ),
      ),
    );
  }
}
