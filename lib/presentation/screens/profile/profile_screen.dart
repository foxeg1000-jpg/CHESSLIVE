import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chess_live/app/theme/app_theme.dart';
import 'package:chess_live/data/providers/auth_providers.dart';
import 'package:chess_live/app/routes/app_pages.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

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
          'Profile',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: user.when(
        data: (userData) {
          if (userData == null) {
            return Center(
              child: ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.login),
                child: const Text('Login'),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppTheme.neonGradient,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: AppTheme.backgroundColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userData.displayName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          '@${userData.username}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          label: 'Rating',
                          value: userData.eloRating.toString(),
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          label: 'Matches',
                          value: userData.totalMatches.toString(),
                          color: AppTheme.neonBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          label: 'Win Rate',
                          value: '${(userData.winRate * 100).toStringAsFixed(1)}%',
                          color: AppTheme.neonGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          label: 'Level',
                          value: userData.level.toString(),
                          color: AppTheme.neonPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Recent Matches',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.cardColor,
                    ),
                    child: const Text(
                      'No recent matches',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () async {
                        await ref.read(authServiceProvider).logout();
                        Get.offAllNamed(Routes.login);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF5252), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Color(0xFFFF5252),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.cardColor,
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
