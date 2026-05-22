import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static late String _agoraAppId;
  static late String _agoraToken;
  static late bool _isProduction;

  // AdMob IDs
  static const String androidBannerId = 'ca-app-pub-2251724138048615/3915945883';
  static const String androidInterstitialId = 'ca-app-pub-2251724138048615/2602864212';
  static const String iosBannerId = 'ca-app-pub-2251724138048615/3258990249';
  static const String iosInterstitialId = 'ca-app-pub-2251724138048615/6059350348';

  // Unity Ads IDs
  static const String unityAndroidGameId = '6099324';
  static const String unityIosGameId = '6099325';

  // API Configuration
  static const String baseUrl = 'https://chesslive-api.example.com';
  static const String wsUrl = 'wss://chesslive-ws.example.com';

  static Future<void> initialize() async {
    await dotenv.load();
    
    _agoraAppId = dotenv.env['AGORA_APP_ID'] ?? '';
    _agoraToken = dotenv.env['AGORA_TOKEN'] ?? '';
    _isProduction = dotenv.env['ENVIRONMENT'] == 'production';

    if (_agoraAppId.isEmpty) {
      throw Exception('AGORA_APP_ID not found in .env file');
    }
  }

  static String get agoraAppId => _agoraAppId;
  static String get agoraToken => _agoraToken;
  static bool get isProduction => _isProduction;

  // Chess time controls
  static const Map<String, Duration> timeControls = {
    'bullet_1': Duration(minutes: 1),
    'blitz_3': Duration(minutes: 3),
    'blitz_5': Duration(minutes: 5),
    'rapid_10': Duration(minutes: 10),
    'classic_30': Duration(minutes: 30),
  };

  // Matchmaking timeouts
  static const Duration matchmakingTimeout = Duration(seconds: 30);
  static const Duration voiceConnectionTimeout = Duration(seconds: 10);

  // Performance thresholds
  static const int maxPlayers = 1000000;
  static const int maxConcurrentMatches = 500000;
  static const double adRevenuePriority = 0.95; // 95% revenue optimization
}
