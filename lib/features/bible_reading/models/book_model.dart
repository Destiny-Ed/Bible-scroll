class Book {
  final String name;
  final int chapters;

  Book({required this.name, required this.chapters});
}

class Verse {
  final int verse;
  final String text;

  Verse({required this.verse, required this.text});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verse: json['verse'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verse': verse,
      'text': text,
    };
  }
}
