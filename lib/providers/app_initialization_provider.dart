import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/services/storage_service.dart';
import 'package:springten/providers/auth_provider.dart';

// App initialization state
class AppInitializationState {
  final bool isInitialized;
  final bool isLoading;
  final String? error;

  const AppInitializationState({
    this.isInitialized = false,
    this.isLoading = true,
    this.error,
  });

  AppInitializationState copyWith({
    bool? isInitialized,
    bool? isLoading,
    String? error,
  }) {
    return AppInitializationState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// App initialization notifier
class AppInitializationNotifier extends StateNotifier<AppInitializationState> {
  AppInitializationNotifier(this._authNotifier) : super(const AppInitializationState());

  final AuthNotifier _authNotifier;

  // Initialize app
  Future<void> initialize() async {
    try {
      // Check if user is already logged in
      final isLoggedIn = await StorageService.isLoggedIn();
      
      if (isLoggedIn) {
        // Load stored user data
        final token = await StorageService.getStoredToken();
        final user = await StorageService.getStoredUser();
        
        if (token != null && user != null) {
          _authNotifier.setUser(user, token);
        }
      }
      
      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// App initialization provider
final appInitializationProvider = StateNotifierProvider<AppInitializationNotifier, AppInitializationState>((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return AppInitializationNotifier(authNotifier);
});

// Convenience provider for checking if app is initialized
final isAppInitializedProvider = Provider<bool>((ref) {
  return ref.watch(appInitializationProvider).isInitialized;
});

// Convenience provider for checking if app is loading
final isAppLoadingProvider = Provider<bool>((ref) {
  return ref.watch(appInitializationProvider).isLoading;
});
