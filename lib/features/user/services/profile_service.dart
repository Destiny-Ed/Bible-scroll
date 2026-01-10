import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('profiles').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!)..id = uid;
    }
    return null;
  }

  Future<void> updateUserProfile(String uid, UserModel user) async {
    await _firestore.collection('profiles').doc(uid).update(user.toMap());
  }
}
