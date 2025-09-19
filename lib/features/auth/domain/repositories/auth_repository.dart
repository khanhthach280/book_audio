import '../entities/user.dart';
import '../../../../core/errors/failures.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<({User? user, Failure? failure})> login({
    required String email,
    required String password,
  });
  
  /// Sign up with email and password
  Future<({User? user, Failure? failure})> signUp({
    required String email,
    required String password,
    required String name,
  });
  
  /// Logout current user
  Future<({bool success, Failure? failure})> logout();
  
  /// Get current user
  Future<({User? user, Failure? failure})> getCurrentUser();
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated();
  
  /// Send password reset email
  Future<({bool success, Failure? failure})> sendPasswordResetEmail(String email);
  
  /// Save user data locally
  Future<({bool success, Failure? failure})> saveUser(User user);
  
  /// Clear user data locally
  Future<({bool success, Failure? failure})> clearUser();
  
  /// Save auth token
  Future<({bool success, Failure? failure})> saveToken(String token);
  
  /// Get auth token
  Future<String?> getToken();
  
  /// Clear auth token
  Future<({bool success, Failure? failure})> clearToken();
}
