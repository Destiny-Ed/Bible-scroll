class UserModel {
  String? id;
  final String? name;
  final String? userName;
  final String? bio;
  final String? email;
  final String? fcmToken;
  final String? platform;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.fcmToken,
    this.platform,
    this.bio,
    this.userName,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return UserModel(
      id: id,
      name: data['name'],
      email: data['email'],
      bio: data['bio'],
      userName: data['userName'],
      fcmToken: data['fcmToken'],
      platform: data['platform'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'name': name,
      "bio": bio,
      "userName": userName,
      'email': email,
      'fcmToken': fcmToken,
      'platform': platform,
    };
  }
}
