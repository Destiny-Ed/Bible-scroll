import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  UserModel? _user;
  UserModel? get user => _user;

  bool get showAdmin => _esterCount >= 30;

  int _esterCount = 0;

  void incrementEsterCount() {
    _esterCount++;
    notifyListeners();
  }

  Future<void> getUserProfile(String uid) async {
    _user = await _profileService.getUserProfile(uid);
    notifyListeners();
  }

  Future<void> updateUserProfile(String uid, UserModel user) async {
    await _profileService.updateUserProfile(uid, user);
    _user = user;
    notifyListeners();
  }
}
