class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? fcmToken;
  final String? platform;

  UserModel({this.id, this.name, this.email, this.fcmToken, this.platform});

  factory UserModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return UserModel(
      id: id,
      name: data['name'],
      email: data['email'],
      fcmToken: data['fcmToken'],
      platform: data['platform'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'fcmToken': fcmToken,
      'platform': platform,
    };
  }
}
