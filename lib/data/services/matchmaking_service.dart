import 'dart:async';

class MatchmakingService {
  static final MatchmakingService _instance = MatchmakingService._internal();
  
  final _matchFoundController = StreamController<String>.broadcast();
  Stream<String> get matchFoundStream => _matchFoundController.stream;
  
  bool _isSearching = false;
  Timer? _searchTimer;
  
  factory MatchmakingService() {
    return _instance;
  }

  MatchmakingService._internal();

  Future<void> startMatchmaking({
    required String userId,
    required String timeControl,
    required int eloRating,
  }) async {
    _isSearching = true;
    
    // Start searching on backend
    // This would typically send a request to your WebSocket server
    // For now, simulating with a timer
    
    _searchTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Check for match found
      // This would be handled by WebSocket listener in real app
    });
  }

  void cancelMatchmaking() {
    _isSearching = false;
    _searchTimer?.cancel();
  }

  void notifyMatchFound(String matchId) {
    _matchFoundController.add(matchId);
    _isSearching = false;
    _searchTimer?.cancel();
  }

  bool get isSearching => _isSearching;

  Future<void> dispose() async {
    _searchTimer?.cancel();
    await _matchFoundController.close();
  }
}
