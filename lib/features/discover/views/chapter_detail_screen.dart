import 'package:flutter/material.dart';

class ChapterDetailScreen extends StatefulWidget {
  final String chapterTitle;

  const ChapterDetailScreen({super.key, required this.chapterTitle});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  late Future<Map<String, dynamic>> _chapterDetails;

  @override
  void initState() {
    super.initState();
    _chapterDetails = _fetchChapterDetails();
  }

  Future<Map<String, dynamic>> _fetchChapterDetails() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, you would fetch this data from an API
    return {
      'summary':
          'This is a summary of the chapter. It provides an overview of the key themes and events discussed in this section of the scripture. The summary helps to provide context and understanding before diving into the individual verses.',
      'verses': [
        {'number': 1, 'text': 'In the beginning God created the heavens and the earth.'},
        {
          'number': 2,
          'text':
              'Now the earth was formless and empty, darkness was over the surface of the deep, and the Spirit of God was hovering over the waters.'
        },
        {'number': 3, 'text': 'And God said, “Let there be light,” and there was light.'},
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.chapterTitle),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Summary'),
              Tab(text: 'Verses'),
            ],
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _chapterDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final summary = snapshot.data!['summary'] as String;
              final verses = snapshot.data!['verses'] as List<Map<String, dynamic>>;

              return TabBarView(
                children: [
                  // Summary Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(summary),
                  ),
                  // Verses Tab
                  ListView.builder(
                    itemCount: verses.length,
                    itemBuilder: (context, index) {
                      final verse = verses[index];
                      return ListTile(
                        title: Text('Verse ${verse['number']}'),
                        subtitle: Text(verse['text']),
                      );
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No data found.'));
            }
          },
        ),
      ),
    );
  }
}