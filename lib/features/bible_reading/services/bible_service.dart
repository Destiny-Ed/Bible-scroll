import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book_model.dart'; // Assuming Verse is defined here

class BibleService {
  static String _bibleApiUrl(String bookName, int chapter) =>
      'https://bible-api.com/$bookName+$chapter?translation=kjv';

  static Future<void> initHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }

  Future<List<Verse>> fetchAndCacheVerses(String bookName, int chapter) async {
    final box = await Hive.openBox('bibleVerses');
    final cacheKey =
        '$bookName-$chapter-kjv'; //TODO: Include translation for future-proofing

    // Try cache first
    if (box.containsKey(cacheKey)) {
      final cachedData = box.get(cacheKey);
      if (cachedData is List) {
        try {
          return cachedData
              .map((e) => Verse.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (e) {
          log('Cache parse error: $e → will refetch');
        }
      }
    }

    //  Fetch from API
    try {
      final url = _bibleApiUrl(bookName, chapter);
      log('Fetching Bible chapter: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        log('API response received: ${data['reference']}');

        // Parse the verses array
        final List<dynamic> versesJson = data['verses'] as List<dynamic>? ?? [];

        final List<Verse> verses = versesJson.map((verseJson) {
          final map = verseJson as Map<String, dynamic>;
          return Verse(
            verse: map['verse'] as int? ?? 0,
            text: (map['text'] as String?)?.trim() ?? '',
          );
        }).toList();

        // Cache as JSON-serializable list
        final jsonList = verses.map((v) => v.toJson()).toList();
        await box.put(cacheKey, jsonList);

        log('Cached ${verses.length} verses for $cacheKey');
        return verses;
      } else {
        log('API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load Bible verses: ${response.statusCode}');
      }
    } catch (e) {
      log('Bible fetch error: $e');
      rethrow;
    }
  }
}
