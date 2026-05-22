import 'package:cloud_firestore/cloud_firestore.dart';

enum MatchStatus { pending, active, completed, abandoned }
enum TimeControl { bullet, blitz, rapid, classic }
enum GameResult { whiteWin, blackWin, draw, abandoned }

class MatchModel {
  final String matchId;
  final String whitePlayerId;
  final String blackPlayerId;
  final String? whiteName;
  final String? blackName;
  final TimeControl timeControl;
  final MatchStatus status;
  final GameResult? result;
  final String pgn;
  final List<String> moves;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int whiteTimeRemaining;
  final int blackTimeRemaining;
  final int whiteRatingBefore;
  final int whiteRatingAfter;
  final int blackRatingBefore;
  final int blackRatingAfter;
  final String? reason; // checkmate, resignation, timeout, etc.

  MatchModel({
    required this.matchId,
    required this.whitePlayerId,
    required this.blackPlayerId,
    this.whiteName,
    this.blackName,
    required this.timeControl,
    required this.status,
    this.result,
    this.pgn = '',
    this.moves = const [],
    required this.createdAt,
    this.startedAt,
    this.endedAt,
    this.whiteTimeRemaining = 0,
    this.blackTimeRemaining = 0,
    required this.whiteRatingBefore,
    this.whiteRatingAfter,
    required this.blackRatingBefore,
    this.blackRatingAfter,
    this.reason,
  });

  factory MatchModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MatchModel(
      matchId: doc.id,
      whitePlayerId: data['whitePlayerId'] ?? '',
      blackPlayerId: data['blackPlayerId'] ?? '',
      whiteName: data['whiteName'],
      blackName: data['blackName'],
      timeControl: TimeControl.values[data['timeControl'] ?? 0],
      status: MatchStatus.values[data['status'] ?? 0],
      result: data['result'] != null ? GameResult.values[data['result']] : null,
      pgn: data['pgn'] ?? '',
      moves: List<String>.from(data['moves'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      startedAt: (data['startedAt'] as Timestamp?)?.toDate(),
      endedAt: (data['endedAt'] as Timestamp?)?.toDate(),
      whiteTimeRemaining: data['whiteTimeRemaining'] ?? 0,
      blackTimeRemaining: data['blackTimeRemaining'] ?? 0,
      whiteRatingBefore: data['whiteRatingBefore'] ?? 1200,
      whiteRatingAfter: data['whiteRatingAfter'],
      blackRatingBefore: data['blackRatingBefore'] ?? 1200,
      blackRatingAfter: data['blackRatingAfter'],
      reason: data['reason'],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'whitePlayerId': whitePlayerId,
    'blackPlayerId': blackPlayerId,
    'whiteName': whiteName,
    'blackName': blackName,
    'timeControl': timeControl.index,
    'status': status.index,
    'result': result?.index,
    'pgn': pgn,
    'moves': moves,
    'createdAt': Timestamp.fromDate(createdAt),
    'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
    'endedAt': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
    'whiteTimeRemaining': whiteTimeRemaining,
    'blackTimeRemaining': blackTimeRemaining,
    'whiteRatingBefore': whiteRatingBefore,
    'whiteRatingAfter': whiteRatingAfter,
    'blackRatingBefore': blackRatingBefore,
    'blackRatingAfter': blackRatingAfter,
    'reason': reason,
  };

  MatchModel copyWith({
    String? matchId,
    String? whitePlayerId,
    String? blackPlayerId,
    String? whiteName,
    String? blackName,
    TimeControl? timeControl,
    MatchStatus? status,
    GameResult? result,
    String? pgn,
    List<String>? moves,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? endedAt,
    int? whiteTimeRemaining,
    int? blackTimeRemaining,
    int? whiteRatingBefore,
    int? whiteRatingAfter,
    int? blackRatingBefore,
    int? blackRatingAfter,
    String? reason,
  }) {
    return MatchModel(
      matchId: matchId ?? this.matchId,
      whitePlayerId: whitePlayerId ?? this.whitePlayerId,
      blackPlayerId: blackPlayerId ?? this.blackPlayerId,
      whiteName: whiteName ?? this.whiteName,
      blackName: blackName ?? this.blackName,
      timeControl: timeControl ?? this.timeControl,
      status: status ?? this.status,
      result: result ?? this.result,
      pgn: pgn ?? this.pgn,
      moves: moves ?? this.moves,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      whiteTimeRemaining: whiteTimeRemaining ?? this.whiteTimeRemaining,
      blackTimeRemaining: blackTimeRemaining ?? this.blackTimeRemaining,
      whiteRatingBefore: whiteRatingBefore ?? this.whiteRatingBefore,
      whiteRatingAfter: whiteRatingAfter ?? this.whiteRatingAfter,
      blackRatingBefore: blackRatingBefore ?? this.blackRatingBefore,
      blackRatingAfter: blackRatingAfter ?? this.blackRatingAfter,
      reason: reason ?? this.reason,
    );
  }
}
