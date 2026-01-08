
import 'package:flutter/material.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Library', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Saved Videos'),
              Tab(text: 'Bookmarked Chapters'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSavedVideosList(),
            _buildBookmarkedChaptersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedVideosList() {
    return ListView.builder(
      itemCount: 4, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage('https://picsum.photos/200/300'), // Replace with actual thumbnail
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: const Text('Video Title', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Creator Name'),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildBookmarkedChaptersList() {
    return ListView.builder(
      itemCount: 6, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            leading: const Icon(Icons.bookmark, color: Color(0xFF4A4A6A)),
            title: Text('Genesis ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('A brief summary of the chapter...'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        );
      },
    );
  }
}
