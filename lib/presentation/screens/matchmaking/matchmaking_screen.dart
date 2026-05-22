import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:chess_live/app/theme/app_theme.dart';
import 'package:chess_live/app/routes/app_pages.dart';
import 'package:chess_live/data/providers/matchmaking_providers.dart';

class MatchmakingScreen extends ConsumerStatefulWidget {
  const MatchmakingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends ConsumerState<MatchmakingScreen> {
  String _selectedTimeControl = 'blitz_3';
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
  }

  void _startMatchmaking() {
    ref.read(matchmakingStateProvider.notifier).startMatchmaking(
      userId: 'current_user_id',
      timeControl: _selectedTimeControl,
      eloRating: 1200,
    );
  }

  void _cancelMatchmaking() {
    ref.read(matchmakingStateProvider.notifier).cancelMatchmaking();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final matchmakingState = ref.watch(matchmakingStateProvider);
    final isSearching = matchmakingState.status == MatchmakingStatus.searching;

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
          'Find Match',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isSearching) ...
              [
                const SizedBox(height: 32),
                const Text(
                  'Select Time Control',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 32),
                _buildTimeControlOption(
                  label: 'Bullet',
                  subtitle: '1 min per side',
                  icon: '🔫',
                  value: 'bullet_1',
                  selected: _selectedTimeControl == 'bullet_1',
                  onTap: () {
                    setState(() => _selectedTimeControl = 'bullet_1');
                  },
                ),
                const SizedBox(height: 16),
                _buildTimeControlOption(
                  label: 'Blitz',
                  subtitle: '3 min per side',
                  icon: '⚡',
                  value: 'blitz_3',
                  selected: _selectedTimeControl == 'blitz_3',
                  onTap: () {
                    setState(() => _selectedTimeControl = 'blitz_3');
                  },
                ),
                const SizedBox(height: 16),
                _buildTimeControlOption(
                  label: 'Blitz',
                  subtitle: '5 min per side',
                  icon: '⚡',
                  value: 'blitz_5',
                  selected: _selectedTimeControl == 'blitz_5',
                  onTap: () {
                    setState(() => _selectedTimeControl = 'blitz_5');
                  },
                ),
                const SizedBox(height: 16),
                _buildTimeControlOption(
                  label: 'Rapid',
                  subtitle: '10 min per side',
                  icon: '🚀',
                  value: 'rapid_10',
                  selected: _selectedTimeControl == 'rapid_10',
                  onTap: () {
                    setState(() => _selectedTimeControl = 'rapid_10');
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _startMatchmaking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Find Match',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ] else ...
              [
                const SizedBox(height: 64),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.neonGradient,
                    boxShadow: AppTheme.glassBoxShadow,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.search,
                      size: 100,
                      color: AppTheme.backgroundColor,
                    ),
                  ),
                )
                    .animate()
                    .scale(duration: 2000.ms)
                    .then()
                    .scale(duration: 2000.ms, begin: const Offset(0.8, 0.8)),
                const SizedBox(height: 48),
                const Text(
                  'Finding Opponent...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _secondsElapsed >= 30
                      ? 'Still searching... ${_secondsElapsed}s'
                      : '${_secondsElapsed}s elapsed',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 48),
                _buildSearchIndicator(),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _cancelMatchmaking,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeControlOption({
    required String label,
    required String subtitle,
    required String icon,
    required String value,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.cardColor,
          border: Border.all(
            color: selected ? AppTheme.primaryColor : AppTheme.borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppTheme.primaryColor : AppTheme.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor,
                ),
                child: const Icon(Icons.check, color: AppTheme.backgroundColor, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(0),
        const SizedBox(width: 8),
        _buildDot(1),
        const SizedBox(width: 8),
        _buildDot(2),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryColor.withOpacity(0.5),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          duration: 1000.ms,
          delay: Duration(milliseconds: index * 200),
        );
  }
}
