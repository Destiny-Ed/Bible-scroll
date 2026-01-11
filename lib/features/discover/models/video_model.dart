class Video {
  final String id;
  final String chapterTitle;
  final String chapter;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String uploader;
  final String avatarUrl;
  final String topic;
  final int likesCount;
  final int bookmarksCount;
  final int commentsCount;
  final int viewsCount;
  final List<Comments> commentsList;

  // UI-only flags (not stored in Firestore)
  bool isLiked;
  bool isBookmarked;

  Video({
    required this.id,
    required this.chapterTitle,
    required this.chapter,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.uploader,
    required this.avatarUrl,
    required this.topic,
    this.likesCount = 0,
    this.bookmarksCount = 0,
    this.commentsCount = 0,
    this.viewsCount = 0,
    this.commentsList = const [],
    this.isLiked = false,
    this.isBookmarked = false,
  });

  factory Video.fromMap(
    Map<String, dynamic> map, {
    bool isLiked = false,
    bool isBookmarked = false,
  }) {
    return Video(
      id: map['id'] ?? '',
      chapterTitle: map['chapterTitle'] ?? '',
      chapter: map['chapter'] ?? '',
      description: map['description'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      uploader: map['uploader'] ?? 'Anonymous',
      avatarUrl: map['avatarUrl'] ?? '',
      topic: map['topic'] ?? '',
      likesCount: map['likesCount'] ?? 0,
      bookmarksCount: map['bookmarksCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      viewsCount: map['viewsCount'] ?? 0,
      commentsList:
          (map['commentsList'] as List<dynamic>?)
              ?.map((c) => Comments.fromMap(c as Map<String, dynamic>))
              .toList() ??
          [],
      isLiked: isLiked,
      isBookmarked: isBookmarked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterTitle': chapterTitle,
      'chapter': chapter,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'uploader': uploader,
      'avatarUrl': avatarUrl,
      'topic': topic,
      'likesCount': likesCount,
      'bookmarksCount': bookmarksCount,
      'commentsCount': commentsCount,
      'viewsCount': viewsCount,
      // commentsList is usually stored in subcollection, so we don't serialize it here
      // If you want to cache some preview comments, you can add:
      // 'commentsList': commentsList.map((c) => c.toMap()).toList(),
    }..removeWhere(
      (key, value) => value == null || (value is String && value.isEmpty),
    );
  }
}

class Comments {
  final String id;
  final String commenterId;
  final String comment;
  final String commenterName;
  final String avatarUrl;
  final DateTime timeStamp;

  Comments({
    required this.id,
    required this.commenterId,
    required this.comment,
    required this.commenterName,
    required this.avatarUrl,
    required this.timeStamp,
  });

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      id: map['id'] ?? '',
      comment: map['comment'] ?? '',
      commenterId: map['commenterId'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      commenterName: map['commenterName'] ?? '',
      timeStamp: DateTime.parse(map['avatarUrl'] ?? ""),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comment': comment,
      'commenterId': commenterId,
      'commenterName': commenterName,
      'timeStamp': timeStamp.toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }
}
