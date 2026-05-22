import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:chess_live/app/routes/app_pages.dart';
import 'package:chess_live/app/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAllNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.neonGradient,
                boxShadow: AppTheme.glassBoxShadow,
              ),
              child: const Icon(
                Icons.chess,
                size: 80,
                color: AppTheme.backgroundColor,
              ),
            )
                .animate()
                .scale(duration: 1000.ms, begin: const Offset(0.5, 0.5))
                .then()
                .shimmer(duration: 2000.ms),
            const SizedBox(height: 24),
            const Text(
              'ChessLive',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                fontFamily: 'Poppins',
                letterSpacing: 2,
              ),
            )
                .animate()
                .fadeIn(duration: 1000.ms)
                .slideY(begin: 0.5),
            const SizedBox(height: 8),
            const Text(
              'Play Chess. Talk Live.',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
                fontFamily: 'Poppins',
              ),
            )
                .animate()
                .fadeIn(duration: 1200.ms)
                .slideY(begin: 0.5),
            const SizedBox(height: 48),
            SizedBox(
              width: 200,
              height: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  backgroundColor: AppTheme.cardColor,
                  valueColor: AlwaysStoppedAnimation(
                    AppTheme.primaryColor.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
