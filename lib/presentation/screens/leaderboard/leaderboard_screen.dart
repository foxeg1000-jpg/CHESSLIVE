import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chess_live/app/theme/app_theme.dart';
import 'package:chess_live/data/providers/auth_providers.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboard = ref.watch(leaderboardProvider);

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
          'Global Leaderboard',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: leaderboard.when(
        data: (players) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            final medal = index == 0 ? '🥇' : index == 1 ? '🥈' : index == 2 ? '🥉' : '${index + 1}';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.cardColor,
                border: Border.all(
                  color: index < 3 ? AppTheme.primaryColor.withOpacity(0.3) : AppTheme.borderColor,
                  width: index < 3 ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    medal,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.username,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          '${player.wins}W ${player.totalMatches - player.wins - player.draws}L ${player.draws}D',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${player.eloRating}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: index < 3 ? AppTheme.primaryColor : AppTheme.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
