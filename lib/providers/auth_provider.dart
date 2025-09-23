import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/models/user_model.dart';
import 'package:springten/services/api_service.dart';
import 'package:springten/services/storage_service.dart';

// Auth state class
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? token;
  final String? error;
  final String? recoveryPhrase;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.token,
    this.error,
    this.recoveryPhrase,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? token,
    String? error,
    String? recoveryPhrase,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error ?? this.error,
      recoveryPhrase: recoveryPhrase ?? this.recoveryPhrase,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  // Login method
  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await ApiService.loginUser(
        username: username,
        password: password,
      );

      final authResponse = AuthResponse.fromJson(response);
      
      // Get user info from wallet info endpoint
      final walletInfo = await ApiService.getWalletInfo(authResponse.token);
      
      // Create user model
      final user = UserModel(
        username: authResponse.username,
        email: '', // Email not returned from login
        fullName: walletInfo['fullName'] ?? '',
        biometricEnabled: walletInfo['biometricEnabled'] ?? false,
        walletAddress: walletInfo['address'],
        status: 'ACTIVE',
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        token: authResponse.token,
        error: null,
      );
      
      // Save to storage
      await StorageService.saveAuthData(authResponse.token, user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // Create wallet only (no username/email required)
  Future<void> createWalletOnly() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await ApiService.createWalletOnly();
      
      // Create user model from response
      final user = UserModel(
        username: response['userId']?.toString() ?? 'wallet_user',
        email: 'wallet@springten.app',
        fullName: 'Wallet User',
        biometricEnabled: false,
        walletAddress: response['address'],
        status: 'ACTIVE',
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        token: response['token'],
        recoveryPhrase: response['recoveryPhrase'],
        error: null,
      );
      
      // Save to storage
      await StorageService.saveAuthData(response['token'], user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // Import wallet using recovery phrase
  Future<void> importWallet(String recoveryPhrase) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await ApiService.importWallet(recoveryPhrase);
      
      // Create user model from response
      final user = UserModel(
        username: response['userId']?.toString() ?? 'imported_user',
        email: 'imported@springten.app',
        fullName: 'Imported Wallet User',
        biometricEnabled: false,
        walletAddress: response['address'],
        status: 'ACTIVE',
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        token: response['token'],
        recoveryPhrase: response['recoveryPhrase'],
        error: null,
      );
      
      // Save to storage
      await StorageService.saveAuthData(response['token'], user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // Logout method
  Future<void> logout() async {
    // Clear storage
    await StorageService.clearAuthData();
    state = const AuthState();
  }

  // Set user from stored data
  void setUser(UserModel user, String token) {
    state = state.copyWith(
      isAuthenticated: true,
      user: user,
      token: token,
    );
  }

  // Initialize auth state from storage
  Future<void> initializeFromStorage() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final token = await StorageService.getStoredToken();
      final user = await StorageService.getStoredUser();
      
      if (token != null && user != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          token: token,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load stored data',
      );
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Update user name
  Future<void> updateUserName(String newName) async {
    if (state.user != null && state.token != null) {
      final updatedUser = UserModel(
        username: state.user!.username,
        email: state.user!.email,
        fullName: newName,
        biometricEnabled: state.user!.biometricEnabled,
        walletAddress: state.user!.walletAddress,
        status: state.user!.status,
      );
      
      // Update state
      state = state.copyWith(user: updatedUser);
      
      // Save to storage
      await StorageService.saveAuthData(state.token!, updatedUser);
    }
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Convenience providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final authTokenProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).token;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final recoveryPhraseProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).recoveryPhrase;
});
