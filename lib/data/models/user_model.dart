import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String displayName;
  final String? photoUrl;
  final int eloRating;
  final int totalMatches;
  final int wins;
  final int losses;
  final int draws;
  final List<String> friendsList;
  final List<String> blockedUsers;
  final DateTime createdAt;
  final DateTime lastActive;
  final bool isOnline;
  final String country;
  final int level;
  final double winRate;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.displayName,
    this.photoUrl,
    this.eloRating = 1200,
    this.totalMatches = 0,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.friendsList = const [],
    this.blockedUsers = const [],
    required this.createdAt,
    required this.lastActive,
    this.isOnline = false,
    this.country = 'US',
    this.level = 1,
    this.winRate = 0.0,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      eloRating: data['eloRating'] ?? 1200,
      totalMatches: data['totalMatches'] ?? 0,
      wins: data['wins'] ?? 0,
      losses: data['losses'] ?? 0,
      draws: data['draws'] ?? 0,
      friendsList: List<String>.from(data['friendsList'] ?? []),
      blockedUsers: List<String>.from(data['blockedUsers'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActive: (data['lastActive'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isOnline: data['isOnline'] ?? false,
      country: data['country'] ?? 'US',
      level: data['level'] ?? 1,
      winRate: (data['wins'] ?? 0) / (data['totalMatches'] ?? 1).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'email': email,
    'username': username,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'eloRating': eloRating,
    'totalMatches': totalMatches,
    'wins': wins,
    'losses': losses,
    'draws': draws,
    'friendsList': friendsList,
    'blockedUsers': blockedUsers,
    'createdAt': Timestamp.fromDate(createdAt),
    'lastActive': Timestamp.fromDate(lastActive),
    'isOnline': isOnline,
    'country': country,
    'level': level,
  };

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    String? displayName,
    String? photoUrl,
    int? eloRating,
    int? totalMatches,
    int? wins,
    int? losses,
    int? draws,
    List<String>? friendsList,
    List<String>? blockedUsers,
    DateTime? createdAt,
    DateTime? lastActive,
    bool? isOnline,
    String? country,
    int? level,
    double? winRate,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      eloRating: eloRating ?? this.eloRating,
      totalMatches: totalMatches ?? this.totalMatches,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      friendsList: friendsList ?? this.friendsList,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      isOnline: isOnline ?? this.isOnline,
      country: country ?? this.country,
      level: level ?? this.level,
      winRate: winRate ?? this.winRate,
    );
  }
}
