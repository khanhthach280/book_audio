import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/firebase/firebase_auth_service.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._firebaseAuthService,
    this._localDataSource,
    this._networkInfo,
  );
  
  final FirebaseAuthService _firebaseAuthService;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  @override
  Future<({User? user, Failure? failure})> login({
    required String email,
    required String password,
  }) async {
    try {
      // Check network connectivity
      if (!await _networkInfo.isConnected) {
        return (
          user: null,
          failure: const NoInternetFailure(
            message: 'No internet connection',
            code: 'NO_INTERNET',
          ),
        );
      }

      print('======== _firebaseAuthService.signInWithEmailAndPassword');
      
      // Sign in with Firebase
      final userModel = await _firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Save user data locally
      await _localDataSource.saveUser(userModel);
      
      return (user: userModel.toEntity(), failure: null);
    } on AppException catch (e) {
      return (
        user: null,
        failure: _mapExceptionToFailure(e),
      );
    } catch (e) {
      return (
        user: null,
        failure: const UnknownFailure(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN',
        ),
      );
    }
  }
  
  @override
  Future<({bool success, Failure? failure})> logout() async {
    try {
      // Sign out from Firebase
      await _firebaseAuthService.signOut();
      
      // Clear local data
      await _localDataSource.clearUser();
      await _localDataSource.clearToken();
      
      return (success: true, failure: null);
    } on AppException catch (e) {
      return (
        success: false,
        failure: _mapExceptionToFailure(e),
      );
    } catch (e) {
      return (
        success: false,
        failure: const UnknownFailure(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN',
        ),
      );
    }
  }
  
  @override
  Future<({User? user, Failure? failure})> getCurrentUser() async {
    try {
      // First try to get from Firebase
      final userModel = await _firebaseAuthService.getCurrentUserData();
      if (userModel != null) {
        // Save to local storage
        await _localDataSource.saveUser(userModel);
        return (user: userModel.toEntity(), failure: null);
      }
      
      // Fallback to local storage
      final localUserModel = await _localDataSource.getCurrentUser();
      return (user: localUserModel?.toEntity(), failure: null);
    } on AppException catch (e) {
      return (
        user: null,
        failure: _mapExceptionToFailure(e),
      );
    } catch (e) {
      return (
        user: null,
        failure: const UnknownFailure(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN',
        ),
      );
    }
  }
  
  @override
  Future<({User? user, Failure? failure})> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Check network connectivity
      if (!await _networkInfo.isConnected) {
        return (
          user: null,
          failure: const NoInternetFailure(
            message: 'No internet connection',
            code: 'NO_INTERNET',
          ),
        );
      }
      
      // Sign up with Firebase
      final userModel = await _firebaseAuthService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      
      // Save user data locally
      await _localDataSource.saveUser(userModel);
      
      return (user: userModel.toEntity(), failure: null);
    } on AppException catch (e) {
      return (
        user: null,
        failure: _mapExceptionToFailure(e),
      );
    } catch (e) {
      return (
        user: null,
        failure: const UnknownFailure(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN',
        ),
      );
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    try {
      // Check Firebase authentication
      return _firebaseAuthService.isAuthenticated;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<({bool success, Failure? failure})> sendPasswordResetEmail(String email) async {
    try {
      // Check network connectivity
      if (!await _networkInfo.isConnected) {
        return (
          success: false,
          failure: const NoInternetFailure(
            message: 'No internet connection',
            code: 'NO_INTERNET',
          ),
        );
      }
      
      // Send password reset email
      await _firebaseAuthService.sendPasswordResetEmail(email);
      
      return (success: true, failure: null);
    } on AppException catch (e) {
      return (
        success: false,
        failure: _mapExceptionToFailure(e),
      );
    } catch (e) {
      return (
        success: false,
        failure: const UnknownFailure(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN',
        ),
      );
    }
  }
  
  @override
  Future<({bool success, Failure? failure})> saveUser(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _localDataSource.saveUser(userModel);
      return (success: true, failure: null);
    } on AppException catch (e) {
      return (
        success: false,
        failure: _mapExceptionToFailure(e),
      );
    } catch (e) {
      return (
        success: false,
        failure: const UnknownFailure(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN',
        ),
      );
    }
  }
  
  @override
  Future<({bool success, Failure? failure})> clearUser() async {
    try {
      await _localDataSource.clearUser();
      return (success: true, failure: null);
    } on AppException catch (e) {
      return (
        success: false,
        failure: _mapExceptionToFailure(e),
      );
    } catch (e) {
      return (
        success: false,
        failure: const UnknownFailure(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN',
        ),
      );
    }
  }
  
  @override
  Future<({bool success, Failure? failure})> saveToken(String token) async {
    try {
      await _localDataSource.saveToken(token);
      return (success: true, failure: null);
    } on AppException catch (e) {
      return (
        success: false,
        failure: _mapExceptionToFailure(e),
      );
    } catch (e) {
      return (
        success: false,
        failure: const UnknownFailure(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN',
        ),
      );
    }
  }
  
  @override
  Future<String?> getToken() async {
    try {
      return await _localDataSource.getToken();
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<({bool success, Failure? failure})> clearToken() async {
    try {
      await _localDataSource.clearToken();
      return (success: true, failure: null);
    } on AppException catch (e) {
      return (
        success: false,
        failure: _mapExceptionToFailure(e),
      );
    } catch (e) {
      return (
        success: false,
        failure: const UnknownFailure(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN',
        ),
      );
    }
  }
  
  /// Map exception to failure
  Failure _mapExceptionToFailure(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        return NetworkFailure(
          message: exception.message,
          code: exception.code,
        );
      case ServerException:
        return ServerFailure(
          message: exception.message,
          code: exception.code,
        );
      case TimeoutException:
        return TimeoutFailure(
          message: exception.message,
          code: exception.code,
        );
      case NoInternetException:
        return NoInternetFailure(
          message: exception.message,
          code: exception.code,
        );
      case LocalStorageException:
        return LocalStorageFailure(
          message: exception.message,
          code: exception.code,
        );
      case AuthException:
        return AuthFailure(
          message: exception.message,
          code: exception.code,
        );
      case InvalidCredentialsException:
        return InvalidCredentialsFailure(
          message: exception.message,
          code: exception.code,
        );
      default:
        return UnknownFailure(
          message: exception.message,
          code: exception.code,
        );
    }
  }
}
