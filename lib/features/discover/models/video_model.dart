
class Video {
  final String id;
  final String chapterTitle;
  final String videoUrl;
  final String verseText;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isBookmarked;

  Video({
    required this.id,
    required this.chapterTitle,
    required this.videoUrl,
    required this.verseText,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.isBookmarked = false,
  });
}
