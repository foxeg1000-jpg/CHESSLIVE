import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chess_live/data/models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Register new user
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      // Create user account
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(displayName);

      // Create user document in Firestore
      final userModel = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
        displayName: displayName,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
        whiteRatingBefore: 1200,
        blackRatingBefore: 1200,
      );

      await _firestore.collection('users').doc(userModel.uid).set(
        userModel.toFirestore(),
      );

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Login with email
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update lastActive
      await _firestore.collection('users').doc(userCredential.user!.uid).update({
        'lastActive': DateTime.now(),
        'isOnline': true,
      });

      return await getUserModel(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get user model from Firestore
  Future<UserModel> getUserModel(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    return UserModel.fromFirestore(doc);
  }

  // Update user online status
  Future<void> setUserOnlineStatus(String uid, bool isOnline) async {
    await _firestore.collection('users').doc(uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now(),
    });
  }

  // Logout
  Future<void> logout() async {
    if (currentUser != null) {
      await setUserOnlineStatus(currentUser!.uid, false);
    }
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Delete account
  Future<void> deleteAccount(String uid) async {
    try {
      // Delete user document from Firestore
      await _firestore.collection('users').doc(uid).delete();
      // Delete auth user
      await currentUser?.delete();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with that email';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
