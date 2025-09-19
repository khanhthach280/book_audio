import 'package:equatable/equatable.dart';
import 'user.dart';

/// Authentication state representing the current auth status
class AuthState extends Equatable {
  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });
  
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  
  @override
  List<Object?> get props => [user, isAuthenticated, isLoading, error];
  
  /// Create a copy of this auth state with updated fields
  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
  
  /// Clear error state
  AuthState clearError() {
    return copyWith(error: null);
  }
  
  /// Set loading state
  AuthState setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }
  
  /// Set authenticated state with user
  AuthState setAuthenticated(User user) {
    return copyWith(
      user: user,
      isAuthenticated: true,
      isLoading: false,
      error: null,
    );
  }
  
  /// Set unauthenticated state
  AuthState setUnauthenticated() {
    print('======== setUnauthenticated');
    return const AuthState(
      user: null,
      isAuthenticated: false,
      isLoading: false,
      error: null,
    );
  }
  
  /// Set error state
  AuthState setError(String error) {
    return copyWith(
      error: error,
      isLoading: false,
    );
  }
}
