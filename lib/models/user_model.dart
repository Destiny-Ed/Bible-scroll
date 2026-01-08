
class User {
  final String name;
  final String profileImageUrl;
  final List<String> watchHistory;
  final List<String> achievements;

  User({
    required this.name,
    required this.profileImageUrl,
    this.watchHistory = const [],
    this.achievements = const [],
  });
}
