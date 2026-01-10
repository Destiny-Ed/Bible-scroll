import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      // accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );
    await _createUserProfile(userCredential.user);
    return userCredential;
  }

  Future<UserCredential> signInWithApple() async {
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
    final OAuthProvider oAuthProvider = OAuthProvider("apple.com");
    final AuthCredential credential = oAuthProvider.credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    final UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );
    await _createUserProfile(userCredential.user);
    return userCredential;
  }

  Future<void> _createUserProfile(User? user) async {
    if (user == null) return;
    final doc = await _firestore.collection('profiles').doc(user.uid).get();
    if (!doc.exists) {
      final String? fcmToken = Platform.isAndroid
          ? (await _firebaseMessaging.getToken())
          : (await _firebaseMessaging.getAPNSToken());
      await _firestore.collection('profiles').doc(user.uid).set({
        'email': user.email,
        'name': user.displayName,
        'fcmToken': fcmToken,
        'platform': Platform.operatingSystem,
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
