import 'package:flutter/material.dart';
import 'package:myapp/models/book_model.dart';
import 'package:myapp/views/reading_detail_screen.dart';

class ChapterListScreen extends StatelessWidget {
  final Book book;

  const ChapterListScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: book.chapters,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (context, index) {
          final chapter = index + 1;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadingDetailScreen(
                    book: book,
                    chapter: chapter,
                  ),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  '$chapter',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
