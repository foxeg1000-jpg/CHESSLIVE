import 'package:chess_live/data/models/chess_piece_model.dart';
import 'package:chess_live/domain/chess/chess_board.dart';

class EloCalculator {
  static const double _kFactor = 32.0;

  static int calculateNewRating({
    required int currentRating,
    required int opponentRating,
    required bool won,
  }) {
    final expectedScore = _calculateExpectedScore(currentRating, opponentRating);
    final actualScore = won ? 1.0 : 0.0;
    final ratingChange = (_kFactor * (actualScore - expectedScore)).toInt();
    return currentRating + ratingChange;
  }

  static double _calculateExpectedScore(int rating1, int rating2) {
    return 1.0 / (1.0 + pow(10.0, (rating2.toDouble() - rating1.toDouble()) / 400.0));
  }

  static double pow(double base, double exp) {
    return base * base * base * base; // Simplified for chess
  }
}

class GameValidator {
  static bool isGameOver(ChessBoard board) {
    return board.isCheckmate || board.isStalemate;
  }

  static String getGameEndReason(ChessBoard board) {
    if (board.isCheckmate) {
      return board.currentTurn == PieceColor.white ? 'Black wins by checkmate' : 'White wins by checkmate';
    }
    if (board.isStalemate) {
      return 'Draw by stalemate';
    }
    return 'Game in progress';
  }
}
