# ChessLive 🎯♟️

**Production-Ready Multiplayer Chess Mobile Game with Real-Time Voice Chat**

A modern, premium chess game that combines online multiplayer with real-time social voice interaction. Fast matchmaking, addictive gameplay, and viral moments.

## 🎮 Features

### Core Gameplay
- ✅ Online multiplayer matchmaking
- ✅ Quick Voice Match with automatic voice chat
- ✅ Offline vs AI with multiple difficulty levels
- ✅ Local multiplayer on same device
- ✅ Ranked ELO system with global leaderboard
- ✅ Match history and statistics
- ✅ Reconnect system for dropped connections
- ✅ Spectator mode

### Game Modes
- 🔫 **Bullet** (1+0)
- ⚡ **Blitz** (3+0, 5+0)
- 🚀 **Rapid** (10+0)
- ⏰ **Classic** (30+0)
- 🎨 **Custom Rooms**

### Voice & Social
- 🎙️ Real-time voice chat during matches
- 🔇 Push-to-talk and open mic modes
- 📢 Noise suppression and echo cancellation
- 💬 Text chat with emoji reactions
- 👥 Friend system with invite codes
- 🚫 Reporting and blocking system
- 🟢 Online status tracking
- 📱 Player profiles with avatars

### Premium UI
- 🎨 Futuristic glassmorphism design
- 🌙 Dark mode optimized
- ✨ Neon and luxury effects
- 🎬 Cinematic transitions
- 📊 Animated chess piece movements
- 🎭 Multiple premium board themes
- 📱 Fully responsive layouts

### Monetization
- 💰 Permanent bottom banner ads
- 📺 Post-match interstitial ads
- 🎯 Google AdMob integration
- 🏆 High ad revenue optimization
- 🚫 No ad removal option

## 📱 Platform Support
- iOS 12+
- Android 5.0+

## 🏗️ Architecture

### Technology Stack
```
Frontend:     Flutter + Dart
State Mgmt:   Riverpod + GetX
Backend:      Firebase (Auth, Firestore, Storage)
Real-time:    WebSocket + Socket.IO
Voice:        Agora RTC Engine
Chess:        Stockfish Engine
Ads:          Google AdMob + Unity Ads
Database:     Cloud Firestore + Hive (local)
```

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── app/
│   ├── routes/              # Navigation
│   ├── theme/               # Design system
│   └── config/              # App configuration
├── data/
│   ├── models/              # Data models
│   ├── repositories/        # Data access layer
│   ├── providers/           # Riverpod providers
│   └── services/            # External services
├── presentation/
│   ├── screens/             # UI screens
│   ├── widgets/             # Reusable components
│   ├── controllers/         # Business logic
│   └── animations/          # Custom animations
├── domain/
│   ├── entities/            # Business logic entities
│   └── usecases/            # Use cases
└── utils/
    ├── constants/           # App constants
    └── extensions/          # Dart extensions
```

## 🔧 Setup & Installation

### Prerequisites
- Flutter 3.0+
- Dart 3.0+
- Xcode 14+ (for iOS)
- Android Studio (for Android)
- Firebase account
- Google AdMob account
- Agora account (for voice chat)

### Firebase Setup
1. Create Firebase project at https://console.firebase.google.com
2. Enable Authentication (Email/Password, Google, Apple)
3. Enable Cloud Firestore
4. Enable Firebase Storage
5. Download `google-services.json` (Android)
6. Download `GoogleService-Info.plist` (iOS)

### Installation Steps
```bash
# Clone repository
git clone https://github.com/foxeg1000-jpg/ChessLive.git
cd ChessLive

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Configure Firebase
# - Add google-services.json to android/app/
# - Add GoogleService-Info.plist to ios/Runner/

# Run app
flutter run -d <device_id>
```

## 📊 Firebase Database Schema

### Collections
- `users` - User profiles and data
- `matches` - Match records and history
- `leaderboard` - ELO rankings
- `friendships` - Friend relationships
- `blocks` - Blocked users
- `reports` - User reports
- `active_games` - Ongoing matches

## 💰 Monetization Setup

### Google AdMob
```
Android:
- App ID: ca-app-pub-2251724138048615~7424402906
- Banner: ca-app-pub-2251724138048615/3915945883
- Interstitial: ca-app-pub-2251724138048615/2602864212

iOS:
- App ID: ca-app-pub-2251724138048615~4878130618
- Banner: ca-app-pub-2251724138048615/3258990249
- Interstitial: ca-app-pub-2251724138048615/6059350348
```

## 🚀 Performance Optimization
- ⚡ Optimized for low-end Android devices
- 🎯 Fast loading times (<5s cold start)
- 🎮 60 FPS smooth gameplay
- 🔋 Minimal battery consumption
- 📡 Stable voice communication
- 📦 App size <100MB

## 📈 Growth Strategy
- Viral voice interaction moments
- Social sharing integration
- Referral rewards system
- Daily challenges and achievements
- Tournament events
- Seasonal leaderboards

## 🔐 Security
- End-to-end encrypted voice
- Secure WebSocket connections
- Firebase security rules
- Account verification
- Abuse detection system
- Rate limiting on matchmaking

## 📝 License
Proprietary - ChessLive

## 👥 Support
For issues and feature requests, please create an issue in the repository.

---

**Made with ❤️ for chess lovers worldwide**
