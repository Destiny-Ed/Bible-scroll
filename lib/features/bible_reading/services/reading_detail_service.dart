
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:myapp/features/bible_reading/models/book_model.dart';

class ReadingDetailService {
  Future<List<Verse>> fetchAndCacheVerses(String book, int chapter) async {
    final box = await Hive.openBox<List<dynamic>>('verses');
    final cacheKey = '$book-$chapter';

    if (await box.containsKey(cacheKey)) {
      final cachedVerses = box.get(cacheKey);
      if (cachedVerses != null) {
        return cachedVerses.map((e) => Verse.fromJson(e)).toList();
      }
    }

    // Replace with your actual API call
    final verses = await _fetchVersesFromApi(book, chapter);
    await box.put(cacheKey, verses.map((e) => e.toJson()).toList());
    return verses;
  }

  // Mock API call
  Future<List<Verse>> _fetchVersesFromApi(String book, int chapter) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      20,
      (index) => Verse(
        verse: index + 1,
        text: 'This is the text for verse ${index + 1} of chapter $chapter in the book of $book.',
      ),
    );
  }
}
