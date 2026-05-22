import 'package:chess_live/data/models/chess_piece_model.dart';

class ChessBoard {
  late List<List<ChessPiece?>> _board;
  PieceColor _currentTurn = PieceColor.white;
  bool _isCheckmate = false;
  bool _isStalemate = false;
  bool _isCheck = false;
  List<ChessMove> _moveHistory = [];

  ChessBoard() {
    _initializeBoard();
  }

  void _initializeBoard() {
    _board = List.generate(8, (_) => List.generate(8, (_) => null));

    // Place pawns
    for (int i = 0; i < 8; i++) {
      _board[1][i] = ChessPiece(
        type: PieceType.pawn,
        color: PieceColor.black,
        row: 1,
        col: i,
      );
      _board[6][i] = ChessPiece(
        type: PieceType.pawn,
        color: PieceColor.white,
        row: 6,
        col: i,
      );
    }

    // Place white pieces
    _board[7][0] = ChessPiece(
      type: PieceType.rook,
      color: PieceColor.white,
      row: 7,
      col: 0,
    );
    _board[7][1] = ChessPiece(
      type: PieceType.knight,
      color: PieceColor.white,
      row: 7,
      col: 1,
    );
    _board[7][2] = ChessPiece(
      type: PieceType.bishop,
      color: PieceColor.white,
      row: 7,
      col: 2,
    );
    _board[7][3] = ChessPiece(
      type: PieceType.queen,
      color: PieceColor.white,
      row: 7,
      col: 3,
    );
    _board[7][4] = ChessPiece(
      type: PieceType.king,
      color: PieceColor.white,
      row: 7,
      col: 4,
    );
    _board[7][5] = ChessPiece(
      type: PieceType.bishop,
      color: PieceColor.white,
      row: 7,
      col: 5,
    );
    _board[7][6] = ChessPiece(
      type: PieceType.knight,
      color: PieceColor.white,
      row: 7,
      col: 6,
    );
    _board[7][7] = ChessPiece(
      type: PieceType.rook,
      color: PieceColor.white,
      row: 7,
      col: 7,
    );

    // Place black pieces
    _board[0][0] = ChessPiece(
      type: PieceType.rook,
      color: PieceColor.black,
      row: 0,
      col: 0,
    );
    _board[0][1] = ChessPiece(
      type: PieceType.knight,
      color: PieceColor.black,
      row: 0,
      col: 1,
    );
    _board[0][2] = ChessPiece(
      type: PieceType.bishop,
      color: PieceColor.black,
      row: 0,
      col: 2,
    );
    _board[0][3] = ChessPiece(
      type: PieceType.queen,
      color: PieceColor.black,
      row: 0,
      col: 3,
    );
    _board[0][4] = ChessPiece(
      type: PieceType.king,
      color: PieceColor.black,
      row: 0,
      col: 4,
    );
    _board[0][5] = ChessPiece(
      type: PieceType.bishop,
      color: PieceColor.black,
      row: 0,
      col: 5,
    );
    _board[0][6] = ChessPiece(
      type: PieceType.knight,
      color: PieceColor.black,
      row: 0,
      col: 6,
    );
    _board[0][7] = ChessPiece(
      type: PieceType.rook,
      color: PieceColor.black,
      row: 0,
      col: 7,
    );
  }

  List<List<ChessPiece?>> get board => _board;
  PieceColor get currentTurn => _currentTurn;
  bool get isCheckmate => _isCheckmate;
  bool get isStalemate => _isStalemate;
  bool get isCheck => _isCheck;
  List<ChessMove> get moveHistory => _moveHistory;

  ChessPiece? getPieceAt(int row, int col) {
    if (row < 0 || row > 7 || col < 0 || col > 7) return null;
    return _board[row][col];
  }

  bool isValidMove(ChessMove move) {
    final piece = getPieceAt(move.fromRow, move.fromCol);
    if (piece == null || piece.color != _currentTurn) return false;

    final target = getPieceAt(move.toRow, move.toCol);
    if (target != null && target.color == piece.color) return false;

    switch (piece.type) {
      case PieceType.pawn:
        return _isValidPawnMove(move, piece);
      case PieceType.rook:
        return _isValidRookMove(move);
      case PieceType.knight:
        return _isValidKnightMove(move);
      case PieceType.bishop:
        return _isValidBishopMove(move);
      case PieceType.queen:
        return _isValidQueenMove(move);
      case PieceType.king:
        return _isValidKingMove(move);
    }
  }

  bool _isValidPawnMove(ChessMove move, ChessPiece pawn) {
    final direction = pawn.color == PieceColor.white ? -1 : 1;
    final startRow = pawn.color == PieceColor.white ? 6 : 1;

    // Moving forward
    if (move.fromCol == move.toCol) {
      if (move.toRow == move.fromRow + direction) {
        return getPieceAt(move.toRow, move.toCol) == null;
      }
      if (move.fromRow == startRow && move.toRow == move.fromRow + (2 * direction)) {
        return getPieceAt(move.fromRow + direction, move.toCol) == null &&
            getPieceAt(move.toRow, move.toCol) == null;
      }
    }

    // Capturing
    if ((move.toCol - move.fromCol).abs() == 1 && move.toRow == move.fromRow + direction) {
      return getPieceAt(move.toRow, move.toCol) != null;
    }

    return false;
  }

  bool _isValidRookMove(ChessMove move) {
    if (move.fromRow == move.toRow || move.fromCol == move.toCol) {
      return _isPathClear(move);
    }
    return false;
  }

  bool _isValidBishopMove(ChessMove move) {
    if ((move.fromRow - move.toRow).abs() == (move.fromCol - move.toCol).abs()) {
      return _isPathClear(move);
    }
    return false;
  }

  bool _isValidQueenMove(ChessMove move) {
    return _isValidRookMove(move) || _isValidBishopMove(move);
  }

  bool _isValidKnightMove(ChessMove move) {
    final rowDiff = (move.fromRow - move.toRow).abs();
    final colDiff = (move.fromCol - move.toCol).abs();
    return (rowDiff == 2 && colDiff == 1) || (rowDiff == 1 && colDiff == 2);
  }

  bool _isValidKingMove(ChessMove move) {
    final rowDiff = (move.fromRow - move.toRow).abs();
    final colDiff = (move.fromCol - move.toCol).abs();
    return rowDiff <= 1 && colDiff <= 1 && !(rowDiff == 0 && colDiff == 0);
  }

  bool _isPathClear(ChessMove move) {
    final rowDir = move.toRow > move.fromRow ? 1 : move.toRow < move.fromRow ? -1 : 0;
    final colDir = move.toCol > move.fromCol ? 1 : move.toCol < move.fromCol ? -1 : 0;

    int row = move.fromRow + rowDir;
    int col = move.fromCol + colDir;

    while (row != move.toRow || col != move.toCol) {
      if (getPieceAt(row, col) != null) return false;
      row += rowDir;
      col += colDir;
    }

    return true;
  }

  bool makeMove(ChessMove move) {
    if (!isValidMove(move)) return false;

    final piece = getPieceAt(move.fromRow, move.fromCol)!;
    final target = getPieceAt(move.toRow, move.toCol);

    // Move piece
    _board[move.toRow][move.toCol] = piece.copyWith(
      row: move.toRow,
      col: move.toCol,
      hasMoved: true,
    );
    _board[move.fromRow][move.fromCol] = null;

    _moveHistory.add(move);

    // Check game state
    _currentTurn = _currentTurn == PieceColor.white ? PieceColor.black : PieceColor.white;
    _updateGameState();

    return true;
  }

  void _updateGameState() {
    _isCheck = _isKingInCheck(_currentTurn);
    _isCheckmate = _isCheck && !_hasLegalMoves();
    _isStalemate = !_isCheck && !_hasLegalMoves();
  }

  bool _isKingInCheck(PieceColor color) {
    // Find king position
    int? kingRow, kingCol;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        final piece = getPieceAt(i, j);
        if (piece != null && piece.type == PieceType.king && piece.color == color) {
          kingRow = i;
          kingCol = j;
          break;
        }
      }
    }

    if (kingRow == null || kingCol == null) return false;

    // Check if any opponent piece can attack the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        final piece = getPieceAt(i, j);
        if (piece != null && piece.color != color) {
          if (isValidMove(ChessMove(
            fromRow: i,
            fromCol: j,
            toRow: kingRow,
            toCol: kingCol,
          ))) {
            return true;
          }
        }
      }
    }

    return false;
  }

  bool _hasLegalMoves() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        final piece = getPieceAt(i, j);
        if (piece != null && piece.color == _currentTurn) {
          for (int toRow = 0; toRow < 8; toRow++) {
            for (int toCol = 0; toCol < 8; toCol++) {
              if (isValidMove(ChessMove(
                fromRow: i,
                fromCol: j,
                toRow: toRow,
                toCol: toCol,
              ))) {
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }

  void reset() {
    _board = List.generate(8, (_) => List.generate(8, (_) => null));
    _currentTurn = PieceColor.white;
    _isCheckmate = false;
    _isStalemate = false;
    _isCheck = false;
    _moveHistory = [];
    _initializeBoard();
  }
}
