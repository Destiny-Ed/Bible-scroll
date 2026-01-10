import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<UserCredential> signInWithGoogle() async {
    final userCredential = await _authService.signInWithGoogle();
    notifyListeners();
    return userCredential;
  }

  Future<UserCredential> signInWithApple() async {
    final userCredential = await _authService.signInWithApple();
    notifyListeners();
    return userCredential;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  Stream<User?> get authStateChanges => _authService.authStateChanges;
}
