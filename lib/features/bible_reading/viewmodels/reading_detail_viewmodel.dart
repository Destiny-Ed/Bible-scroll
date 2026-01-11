
import 'package:flutter/foundation.dart';
import 'package:myapp/features/bible_reading/models/book_model.dart';
import 'package:myapp/features/bible_reading/services/reading_detail_service.dart';

class ReadingDetailViewModel extends ChangeNotifier {
  final ReadingDetailService _service;

  ReadingDetailViewModel(this._service);

  List<Verse> _verses = [];
  List<Verse> get verses => _verses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchVerses(String book, int chapter) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _verses = await _service.fetchAndCacheVerses(book, chapter);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
