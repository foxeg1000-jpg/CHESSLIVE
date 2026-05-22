import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chess_live/data/models/match_model.dart';
import 'package:chess_live/data/services/firestore_service.dart';
import 'package:chess_live/data/services/matchmaking_service.dart';

final matchmakingServiceProvider = Provider((ref) => MatchmakingService());

// Watch match stream
final watchMatchProvider = StreamProvider.family<MatchModel, String>((ref, matchId) {
  return ref.watch(FirestoreService().watchMatch(matchId));
});

// Matchmaking state
final matchmakingStateProvider = StateNotifierProvider<MatchmakingController, MatchmakingState>((ref) {
  return MatchmakingController(ref);
});

enum MatchmakingStatus { idle, searching, found, cancelled }

class MatchmakingState {
  final MatchmakingStatus status;
  final String? matchId;
  final int secondsElapsed;

  MatchmakingState({
    required this.status,
    this.matchId,
    required this.secondsElapsed,
  });

  MatchmakingState copyWith({
    MatchmakingStatus? status,
    String? matchId,
    int? secondsElapsed,
  }) {
    return MatchmakingState(
      status: status ?? this.status,
      matchId: matchId ?? this.matchId,
      secondsElapsed: secondsElapsed ?? this.secondsElapsed,
    );
  }
}

class MatchmakingController extends StateNotifier<MatchmakingState> {
  final Ref _ref;

  MatchmakingController(this._ref)
      : super(MatchmakingState(
          status: MatchmakingStatus.idle,
          secondsElapsed: 0,
        ));

  Future<void> startMatchmaking({
    required String userId,
    required String timeControl,
    required int eloRating,
  }) async {
    state = state.copyWith(status: MatchmakingStatus.searching);

    await _ref.watch(matchmakingServiceProvider).startMatchmaking(
      userId: userId,
      timeControl: timeControl,
      eloRating: eloRating,
    );
  }

  void cancelMatchmaking() {
    _ref.watch(matchmakingServiceProvider).cancelMatchmaking();
    state = state.copyWith(status: MatchmakingStatus.cancelled);
  }

  void matchFound(String matchId) {
    state = state.copyWith(
      status: MatchmakingStatus.found,
      matchId: matchId,
    );
  }
}
