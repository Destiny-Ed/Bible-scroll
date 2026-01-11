
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';

class BibleService {
  static const String _bibleApiUrl =
      'https://getbible.net/json?passage={BOOK_NAME}{CHAPTER}';

  Future<void> initHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }

  Future<String> fetchAndCacheVerses(String bookName, int chapter) async {
    final box = await Hive.openBox('bibleVerses');
    final cacheKey = '\$bookName-\$chapter';

    // Check if the data is already in the cache
    if (box.containsKey(cacheKey)) {
      return box.get(cacheKey);
    }

    final response = await http.get(Uri.parse(
        _bibleApiUrl.replaceFirst('{BOOK_NAME}', bookName).replaceFirst('{CHAPTER}', chapter.toString())));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final verses = (data['book'] as List)
          .map((book) => (book['chapter'] as Map<String, dynamic>).values.map((verse) => verse['verse']).join('\\n'))
          .join('\\n\\n');

      // Cache the fetched data
      await box.put(cacheKey, verses);
      return verses;
    } else {
      throw Exception('Failed to load Bible verses');
    }
  }
}
