
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Trending Topics'),
              const SizedBox(height: 16),
              _buildTrendingTopics(),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Popular Videos'),
              const SizedBox(height: 16),
              _buildPopularVideosGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for books or chapters...',
        prefixIcon: const Icon(Icons.search, color: Color(0xFF4A4A6A)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTrendingTopics() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          TopicChip(label: '#faith'),
          TopicChip(label: '#hope'),
          TopicChip(label: '#love'),
          TopicChip(label: '#salvation'),
          TopicChip(label: '#prayer'),
        ],
      ),
    );
  }

  Widget _buildPopularVideosGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: 6, // Replace with actual data
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: NetworkImage('https://picsum.photos/200/300'), // Replace with actual video thumbnail
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.black.withAlpha(102), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Video Title', // Replace with actual video title
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TopicChip extends StatelessWidget {
  final String label;

  const TopicChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label, style: const TextStyle(color: Color(0xFF4A4A6A))),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF4A4A6A), width: 1),
        ),
      ),
    );
  }
}
