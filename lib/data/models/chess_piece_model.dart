enum PieceType { pawn, rook, knight, bishop, queen, king }
enum PieceColor { white, black }

class ChessPiece {
  final PieceType type;
  final PieceColor color;
  final int row;
  final int col;
  final bool hasMoved;

  ChessPiece({
    required this.type,
    required this.color,
    required this.row,
    required this.col,
    this.hasMoved = false,
  });

  String get symbol {
    const Map<PieceType, String> pieces = {
      PieceType.pawn: 'P',
      PieceType.rook: 'R',
      PieceType.knight: 'N',
      PieceType.bishop: 'B',
      PieceType.queen: 'Q',
      PieceType.king: 'K',
    };
    return pieces[type] ?? '';
  }

  String get unicodeSymbol {
    if (color == PieceColor.white) {
      switch (type) {
        case PieceType.pawn:
          return '♙';
        case PieceType.rook:
          return '♖';
        case PieceType.knight:
          return '♘';
        case PieceType.bishop:
          return '♗';
        case PieceType.queen:
          return '♕';
        case PieceType.king:
          return '♔';
      }
    } else {
      switch (type) {
        case PieceType.pawn:
          return '♟';
        case PieceType.rook:
          return '♜';
        case PieceType.knight:
          return '♞';
        case PieceType.bishop:
          return '♝';
        case PieceType.queen:
          return '♛';
        case PieceType.king:
          return '♚';
      }
    }
  }

  ChessPiece copyWith({
    PieceType? type,
    PieceColor? color,
    int? row,
    int? col,
    bool? hasMoved,
  }) {
    return ChessPiece(
      type: type ?? this.type,
      color: color ?? this.color,
      row: row ?? this.row,
      col: col ?? this.col,
      hasMoved: hasMoved ?? this.hasMoved,
    );
  }
}

class ChessMove {
  final int fromRow;
  final int fromCol;
  final int toRow;
  final int toCol;
  final PieceType? promotionPiece;

  ChessMove({
    required this.fromRow,
    required this.fromCol,
    required this.toRow,
    required this.toCol,
    this.promotionPiece,
  });

  String toAlgebraic() {
    const List<String> cols = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    final from = '${cols[fromCol]}${8 - fromRow}';
    final to = '${cols[toCol]}${8 - toRow}';
    return '$from$to';
  }

  @override
  String toString() => toAlgebraic();
}
