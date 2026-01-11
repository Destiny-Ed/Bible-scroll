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
  final int likes;
  final int bookmarks;
  final int comments;
  final List<Comments> commentsList;


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
    required this.likes,
    required this.bookmarks,
    required this.comments,
    required this.commentsList,
  });

  factory Video.fromMap(Map<String, dynamic> map) {
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
      likes: map['likes'] ?? 0,
      bookmarks: map['bookmarks'] ?? 0,
      comments: map['comments'] ?? 0,
      commentsList: List<Comments>.from(
        map['commentsList']?.map((x) => Comments.fromMap(x)) ?? [],
      ),
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
      'likes': likes,
      'bookmarks': bookmarks,
      'comments': comments,
      'commentsList': commentsList.map((x) => x.toMap()).toList(),
    };
  }


}


class Comments {
  final String id;
  final String comment;
  final String commenter;
  final String avatarUrl;

  Comments({
    required this.id,
    required this.comment,
    required this.commenter,
    required this.avatarUrl,
  });

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      id: map['id'] ?? '',
      comment: map['comment'] ?? '',
      commenter: map['commenter'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comment': comment,
      'commenter': commenter,
      'avatarUrl': avatarUrl,
    };
  }
}
