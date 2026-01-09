import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/models/book_model.dart';

class ReadingDetailScreen extends StatefulWidget {
  final Book book;
  final int chapter;

  const ReadingDetailScreen(
      {super.key, required this.book, required this.chapter});

  @override
  ReadingDetailScreenState createState() => ReadingDetailScreenState();
}

class ReadingDetailScreenState extends State<ReadingDetailScreen> {
  String _chapterContent = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchChapterContent();
  }

  Future<void> _fetchChapterContent() async {
    final url =
        "https://bible-api.com/${widget.book.name}+${widget.chapter}?translation=kjv";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _chapterContent = data['text'];
        });
      } else {
        setState(() {
          _chapterContent = "Failed to load chapter content.";
        });
      }
    } catch (e) {
      setState(() {
        _chapterContent = "Failed to load chapter content.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book.name} ${widget.chapter}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _chapterContent,
              style: const TextStyle(fontSize: 18, height: 1.6),
            ),
            const Divider(height: 40),
            _buildReflectionSection(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.bookmark_add_outlined),
      ),
    );
  }

  Widget _buildReflectionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Reflection',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Write your thoughts and reflections here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
