import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chess_live/app/theme/app_theme.dart';
import 'package:chess_live/domain/chess/chess_board.dart';
import 'package:chess_live/data/models/chess_piece_model.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ChessBoard _chessBoard;
  int _whiteTime = 300; // 5 minutes
  int _blackTime = 300;
  int? _selectedRow;
  int? _selectedCol;
  List<List<bool>> _validMoves = List.generate(8, (_) => List.generate(8, (_) => false));

  @override
  void initState() {
    super.initState();
    _chessBoard = ChessBoard();
  }

  void _onSquareTap(int row, int col) {
    final piece = _chessBoard.getPieceAt(row, col);

    if (_selectedRow == null && _selectedCol == null) {
      // Select piece
      if (piece != null && piece.color == _chessBoard.currentTurn) {
        setState(() {
          _selectedRow = row;
          _selectedCol = col;
          _calculateValidMoves(row, col);
        });
      }
    } else {
      // Move piece
      if (_selectedRow == row && _selectedCol == col) {
        // Deselect
        setState(() {
          _selectedRow = null;
          _selectedCol = null;
          _validMoves = List.generate(8, (_) => List.generate(8, (_) => false));
        });
      } else if (_validMoves[row][col]) {
        final move = ChessMove(
          fromRow: _selectedRow!,
          fromCol: _selectedCol!,
          toRow: row,
          toCol: col,
        );

        if (_chessBoard.makeMove(move)) {
          setState(() {
            _selectedRow = null;
            _selectedCol = null;
            _validMoves = List.generate(8, (_) => List.generate(8, (_) => false));
          });
        }
      } else {
        // Select different piece
        if (piece != null && piece.color == _chessBoard.currentTurn) {
          setState(() {
            _selectedRow = row;
            _selectedCol = col;
            _calculateValidMoves(row, col);
          });
        }
      }
    }
  }

  void _calculateValidMoves(int row, int col) {
    _validMoves = List.generate(8, (_) => List.generate(8, (_) => false));

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (_chessBoard.isValidMove(ChessMove(
          fromRow: row,
          fromCol: col,
          toRow: i,
          toCol: j,
        ))) {
          _validMoves[i][j] = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Game',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Opponent info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Opponent',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      '${_blackTime ~/ 60}:${(_blackTime % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.neonPink,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Chess board
              AspectRatio(
                aspectRatio: 1,
                child: _buildChessBoard(),
              ),
              const SizedBox(height: 16),
              // Player info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'You',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      '${_whiteTime ~/ 60}:${(_whiteTime % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Move history
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppTheme.cardColor,
                  ),
                  child: ListView.builder(
                    itemCount: _chessBoard.moveHistory.length,
                    itemBuilder: (context, index) {
                      final move = _chessBoard.moveHistory[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${index + 1}. ${move.toAlgebraic()}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontFamily: 'SpaceMono',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChessBoard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.glassBoxShadow,
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          final row = index ~/ 8;
          final col = index % 8;
          final piece = _chessBoard.getPieceAt(row, col);
          final isLight = (row + col) % 2 == 0;
          final isSelected = _selectedRow == row && _selectedCol == col;
          final isValidMove = _validMoves[row][col];

          return GestureDetector(
            onTap: () => _onSquareTap(row, col),
            child: Container(
              color: isSelected
                  ? AppTheme.primaryColor
                  : isValidMove
                      ? AppTheme.neonGreen.withOpacity(0.3)
                      : isLight
                          ? AppTheme.cardColor
                          : AppTheme.surfaceColor,
              child: Center(
                child: piece != null
                    ? Text(
                        piece.unicodeSymbol,
                        style: const TextStyle(fontSize: 32),
                      )
                    : const SizedBox(),
              ),
            ),
          );
        },
      ),
    );
  }
}
