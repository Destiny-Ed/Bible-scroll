import 'package:flutter/material.dart';

class ChapterDetailScreen extends StatelessWidget {
  const ChapterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter Detail'),
      ),
      body: const Center(
        child: Text('Chapter Detail Screen'),
      ),
    );
  }
}
