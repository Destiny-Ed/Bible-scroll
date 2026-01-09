import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/features/bible_reading/models/book_model.dart';

class ReadingDetailScreen extends StatefulWidget {
  final Book book;
  final int chapter;

  const ReadingDetailScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  ReadingDetailScreenState createState() => ReadingDetailScreenState();
}

class ReadingDetailScreenState extends State<ReadingDetailScreen> {
  String _message = "Loading...";
  List<dynamic> _chapterContent = [];

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
        log(data["reference"]);
        final reference = (data["verses"]);

        setState(() {
          _chapterContent = reference;
        });
      } else {
        setState(() {
          _message = "Failed to load chapter content n.";
        });
      }
    } catch (e) {
      log("Error meesage ::: $e");
      setState(() {
        _message = "Failed to load chapter content.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.book.name} ${widget.chapter}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_chapterContent.isEmpty)
              Text(_message, style: const TextStyle(fontSize: 18, height: 1.6)),

            if (_chapterContent.isNotEmpty)
              ...List.generate(_chapterContent.length, (index) {
                final message = _chapterContent[index] as Map<String, dynamic>;
                return Text(
                  "${message["verse"]} - ${message["text"]}",
                  style: const TextStyle(fontSize: 18, height: 1.6),
                );
              }),
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
        Text('My Reflection', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Write your thoughts and reflections here...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
