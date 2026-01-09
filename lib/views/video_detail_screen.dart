import 'package:flutter/material.dart';

class VideoDetailScreen extends StatelessWidget {
  const VideoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1593509497293-94637355156a?q=80&w=2070&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Finding Peace in Psalms',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'A guided meditation through the most beloved Psalms. This video will help you find tranquility and hope in times of uncertainty.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(height: 40),
            _buildSectionHeader(context, 'Up Next'),
            _buildUpNextList(),
          ],
        ),
      ),
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

    Widget _buildUpNextList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2, // Number of items in the 'Up Next' list
      itemBuilder: (context, index) {
        // Example data - replace with your actual data
        final titles = ['The Story of Moses', 'The Parables of Jesus'];
        final subtitles = ['An animated journey', 'Lessons for modern times'];
        final imageUrls = [
          'https://images.unsplash.com/photo-1605047259183-72e951d72b27?q=80&w=2070&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1598493635232-f0449733d9d2?q=80&w=1974&auto=format&fit=crop',
        ];

        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              // Handle navigation to the next video
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrls[index],
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
                          titles[index],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitles[index],
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

