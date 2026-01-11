class UserModel {
  String? id;
  final String? name;
  final String? userName;
  final String? bio;
  final String? email;
  final String? fcmToken;
  final String? platform;

  // New fields for quick local access to liked/bookmarked videos
  final List<String> likedVideos; // list of video IDs
  final List<String> bookmarkedVideos; // list of video IDs

  UserModel({
    this.id,
    this.name,
    this.userName,
    this.bio,
    this.email,
    this.fcmToken,
    this.platform,
    this.likedVideos = const [],
    this.bookmarkedVideos = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return UserModel(
      id: id,
      name: data['name'],
      userName: data['userName'],
      bio: data['bio'],
      email: data['email'],
      fcmToken: data['fcmToken'],
      platform: data['platform'],
      likedVideos: List<String>.from(data['likedVideos'] ?? []),
      bookmarkedVideos: List<String>.from(data['bookmarkedVideos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'userName': userName,
      'bio': bio,
      'email': email,
      'fcmToken': fcmToken,
      'platform': platform,
      'likedVideos': likedVideos,
      'bookmarkedVideos': bookmarkedVideos,
    };
  }

  // Helper methods
  bool hasLiked(String videoId) => likedVideos.contains(videoId);
  bool hasBookmarked(String videoId) => bookmarkedVideos.contains(videoId);
}
