import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/utils/error_message_service.dart';

/// Auth state provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

/// Auth notifier for managing authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _checkAuthStatus();
  }
  
  final AuthRepository _authRepository;
  
  /// Check authentication status on app start
  Future<void> _checkAuthStatus() async {
    state = state.setLoading(true);
    
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      if (isAuthenticated) {
        final result = await _authRepository.getCurrentUser();
        if (result.user != null) {
          
          state = state.setAuthenticated(result.user!);
        } else {
          state = state.setUnauthenticated();
        }
      } else {
        state = state.setUnauthenticated();
      }
    } catch (e) {
      state = state.setError('Failed to check authentication status');
    }
  }
  
  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {

    state = state.setLoading(true).clearError();
    
    try {
      final result = await _authRepository.login(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        state = state.setAuthenticated(result.user!);
      } else if (result.failure != null) {
        state = state.setError(_getErrorMessage(result.failure!));
      } else {
        state = state.setError('Login failed');
      }
    } catch (e) {
      state = state.setError('An unexpected error occurred');
    }
  }
  
  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.setLoading(true).clearError();
    
    try {
      final result = await _authRepository.signUp(
        email: email,
        password: password,
        name: name,
      );
      
      if (result.user != null) {
        state = state.setAuthenticated(result.user!);
      } else if (result.failure != null) {
        state = state.setError(_getErrorMessage(result.failure!));
      } else {
        state = state.setError('Sign up failed');
      }
    } catch (e) {
      state = state.setError('An unexpected error occurred');
    }
  }
  
  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    state = state.setLoading(true).clearError();
    
    try {
      final result = await _authRepository.sendPasswordResetEmail(email);
      
      if (result.success) {
        state = state.setLoading(false);
        // You might want to show a success message here
      } else if (result.failure != null) {
        state = state.setError(_getErrorMessage(result.failure!));
      } else {
        state = state.setError('Failed to send password reset email');
      }
    } catch (e) {
      state = state.setError('An unexpected error occurred');
    }
  }
  
  /// Logout current user
  Future<void> logout() async {
    state = state.setLoading(true);
    
    try {
      final result = await _authRepository.logout();
      if (result.success) {
        state = state.setUnauthenticated();
      } else if (result.failure != null) {
        state = state.setError(_getErrorMessage(result.failure!));
      } else {
        state = state.setError('Logout failed');
      }
    } catch (e) {
      state = state.setError('An unexpected error occurred');
    }
  }
  
  /// Clear error state
  void clearError() {
    state = state.clearError();
  }
  
  /// Get error message from failure using ErrorMessageService
  String _getErrorMessage(Failure failure) {
    
    // Use ErrorMessageService for centralized error handling
    return ErrorMessageService.getErrorMessage(failure.runtimeType.toString());
  }
}

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isAuthenticated;
});

/// Is loading provider
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isLoading;
});

/// Auth error provider
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.error;
});
