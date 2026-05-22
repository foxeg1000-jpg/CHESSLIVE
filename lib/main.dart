import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize app configuration
  await AppConfig.initialize();

  runApp(
    const ProviderScope(
      child: ChessLiveApp(),
    ),
  );
}

class ChessLiveApp extends StatelessWidget {
  const ChessLiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ChessLive',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      getPages: AppPages.pages,
      initialRoute: AppPages.initial,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      builder: (context, child) {
        return _AppWrapper(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

class _AppWrapper extends StatefulWidget {
  final Widget child;

  const _AppWrapper({required this.child, Key? key}) : super(key: key);

  @override
  State<_AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<_AppWrapper> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Persistent bottom banner ad container
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black87,
            height: 60,
            // Banner ad will be injected here by AdManager
          ),
        ),
      ],
    );
  }
}
