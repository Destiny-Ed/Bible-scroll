import 'package:flutter/material.dart';

class TopicDetailScreen extends StatelessWidget {
  final String topicName;

  const TopicDetailScreen({super.key, required this.topicName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topicName)),
      body: const Center(
        child: Text('Content for this topic will be displayed here.'),
      ),
    );
  }
}
