/// Base class for all exceptions in the application
abstract class AppException implements Exception {
  const AppException({this.message, this.code});
  
  final String? message;
  final String? code;
  
  @override
  String toString() => 'AppException: $message (Code: $code)';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({super.message, super.code});
}

class ServerException extends AppException {
  const ServerException({super.message, super.code});
}

class TimeoutException extends AppException {
  const TimeoutException({super.message, super.code});
}

class NoInternetException extends AppException {
  const NoInternetException({super.message, super.code});
}

/// Local storage exceptions
class LocalStorageException extends AppException {
  const LocalStorageException({super.message, super.code});
}

class CacheException extends AppException {
  const CacheException({super.message, super.code});
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException({super.message, super.code});
}

class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException({super.message, super.code});
}

/// General exceptions
class UnknownException extends AppException {
  const UnknownException({super.message, super.code});
}
