import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardEntry {
  final String userId;
  final String username;
  final String? photoUrl;
  final int eloRating;
  final int rank;
  final int totalMatches;
  final int wins;
  final double winRate;
  final String country;
  final DateTime lastUpdated;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    this.photoUrl,
    required this.eloRating,
    required this.rank,
    required this.totalMatches,
    required this.wins,
    required this.winRate,
    required this.country,
    required this.lastUpdated,
  });

  factory LeaderboardEntry.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return LeaderboardEntry(
      userId: doc.id,
      username: data['username'] ?? '',
      photoUrl: data['photoUrl'],
      eloRating: data['eloRating'] ?? 1200,
      rank: data['rank'] ?? 0,
      totalMatches: data['totalMatches'] ?? 0,
      wins: data['wins'] ?? 0,
      winRate: data['winRate'] ?? 0.0,
      country: data['country'] ?? 'US',
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'username': username,
    'photoUrl': photoUrl,
    'eloRating': eloRating,
    'rank': rank,
    'totalMatches': totalMatches,
    'wins': wins,
    'winRate': winRate,
    'country': country,
    'lastUpdated': Timestamp.fromDate(lastUpdated),
  };
}
