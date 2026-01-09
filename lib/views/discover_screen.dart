import 'package:flutter/material.dart';
import 'package:myapp/views/book_list_screen.dart';
import 'package:myapp/views/video_detail_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFeaturedContent(context),
          const SizedBox(height: 24),
          _buildBrowseBooksButton(context),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Popular Topics'),
          _buildTopicsGrid(),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Recommended Videos'),
          _buildVideosList(context),
        ],
      ),
    );
  }

  Widget _buildFeaturedContent(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VideoDetailScreen()));
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1593509497293-94637355156a?q=80&w=2070&auto=format&fit=crop',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha((255 * 0.7).round()),
                    Colors.transparent
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Finding Peace in Psalms',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A guided meditation through the most beloved Psalms.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseBooksButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookListScreen()),
        );
      },
      child: const Text('Browse Books of the Bible'),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildTopicsGrid() {
    final topics = ['Faith', 'Love', 'Hope', 'Prayer', 'Wisdom', 'Grace'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {},
            child: Center(
              child: Text(
                topics[index],
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 18),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideosList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VideoDetailScreen()));
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1516408529486-db3b24478794?q=80&w=1974&auto=format&fit=crop',
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
                          'The Story of David',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A short animated summary.',
                          style: Theme.of(context).textTheme.labelSmall,
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
