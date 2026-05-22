import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chess_live/data/models/user_model.dart';
import 'package:chess_live/data/models/match_model.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  // Users Collection
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toFirestore());
  }

  Stream<UserModel> watchUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map(
      (doc) => UserModel.fromFirestore(doc),
    );
  }

  Future<List<UserModel>> searchUsers(String query) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThan: query + 'z')
        .limit(20)
        .get();

    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  // Matches Collection
  Future<String> createMatch(MatchModel match) async {
    final docRef = await _firestore.collection('matches').add(match.toFirestore());
    return docRef.id;
  }

  Future<void> updateMatch(MatchModel match) async {
    await _firestore.collection('matches').doc(match.matchId).update(match.toFirestore());
  }

  Stream<MatchModel> watchMatch(String matchId) {
    return _firestore.collection('matches').doc(matchId).snapshots().map(
      (doc) => MatchModel.fromFirestore(doc),
    );
  }

  Future<List<MatchModel>> getUserMatches(String userId, {int limit = 20}) async {
    final snapshot = await _firestore
        .collection('matches')
        .where('whitePlayerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    final blackMatches = await _firestore
        .collection('matches')
        .where('blackPlayerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    final allMatches = [
      ...snapshot.docs.map((doc) => MatchModel.fromFirestore(doc)),
      ...blackMatches.docs.map((doc) => MatchModel.fromFirestore(doc)),
    ];

    allMatches.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allMatches.take(limit).toList();
  }

  // Leaderboard
  Future<List<UserModel>> getLeaderboard({int limit = 100}) async {
    final snapshot = await _firestore
        .collection('users')
        .orderBy('eloRating', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  // Friends
  Future<void> addFriend(String userId, String friendId) async {
    await _firestore.collection('users').doc(userId).update({
      'friendsList': FieldValue.arrayUnion([friendId]),
    });
  }

  Future<void> removeFriend(String userId, String friendId) async {
    await _firestore.collection('users').doc(userId).update({
      'friendsList': FieldValue.arrayRemove([friendId]),
    });
  }

  Future<List<UserModel>> getUserFriends(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final friendsList = List<String>.from(userDoc['friendsList'] ?? []);

    if (friendsList.isEmpty) return [];

    final snapshot = await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: friendsList)
        .get();

    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  // Blocked Users
  Future<void> blockUser(String userId, String blockedUserId) async {
    await _firestore.collection('users').doc(userId).update({
      'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
    });
  }

  Future<void> unblockUser(String userId, String blockedUserId) async {
    await _firestore.collection('users').doc(userId).update({
      'blockedUsers': FieldValue.arrayRemove([blockedUserId]),
    });
  }

  // Reports
  Future<void> reportUser(String reporterId, String reportedUserId, String reason) async {
    await _firestore.collection('reports').add({
      'reporterId': reporterId,
      'reportedUserId': reportedUserId,
      'reason': reason,
      'createdAt': DateTime.now(),
      'status': 'pending',
    });
  }

  // Update ELO rating
  Future<void> updatePlayerRating(String userId, int newRating) async {
    await _firestore.collection('users').doc(userId).update({
      'eloRating': newRating,
    });
  }

  // Batch update
  Future<void> batchUpdateUsers(List<UserModel> users) async {
    final batch = _firestore.batch();
    for (final user in users) {
      final ref = _firestore.collection('users').doc(user.uid);
      batch.update(ref, user.toFirestore());
    }
    await batch.commit();
  }
}
