import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chess_live/data/models/user_model.dart';
import 'package:chess_live/data/services/auth_service.dart';
import 'package:chess_live/data/services/firestore_service.dart';

final authServiceProvider = Provider((ref) => AuthService());
final firestoreServiceProvider = Provider((ref) => FirestoreService());

// Auth state
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Current user
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.whenData((user) {
    if (user != null) {
      return ref.watch(firestoreServiceProvider).getUserModel(user.uid);
    }
    return null;
  }).value;
});

// User by ID
final userByIdProvider = FutureProvider.family<UserModel, String>((ref, uid) async {
  return ref.watch(firestoreServiceProvider).getUserModel(uid);
});

// Watch user stream
final watchUserProvider = StreamProvider.family<UserModel, String>((ref, uid) {
  return ref.watch(firestoreServiceProvider).watchUser(uid);
});

// Leaderboard
final leaderboardProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(firestoreServiceProvider).getLeaderboard();
});

// User friends
final userFriendsProvider = FutureProvider.family<List<UserModel>, String>((ref, userId) async {
  return ref.watch(firestoreServiceProvider).getUserFriends(userId);
});

// User matches
final userMatchesProvider = FutureProvider.family<List<dynamic>, String>((ref, userId) async {
  return ref.watch(firestoreServiceProvider).getUserMatches(userId);
});

// Login controller
final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<void>>((ref) {
  return LoginController(ref);
});

class LoginController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  LoginController(this._ref) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _ref.watch(authServiceProvider).loginWithEmail(
        email: email,
        password: password,
      );
    });
  }
}

// Register controller
final registerControllerProvider = StateNotifierProvider<RegisterController, AsyncValue<void>>((ref) {
  return RegisterController(ref);
});

class RegisterController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  RegisterController(this._ref) : super(const AsyncValue.data(null));

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _ref.watch(authServiceProvider).registerWithEmail(
        email: email,
        password: password,
        username: username,
        displayName: displayName,
      );
    });
  }
}
