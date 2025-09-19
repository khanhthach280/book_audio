import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  const Failure({this.message, this.code});
  
  final String? message;
  final String? code;
  
  @override
  List<Object?> get props => [message, code];
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({super.message, super.code});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message, super.code});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message, super.code});
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({super.message, super.code});
}

/// Local storage failures
class LocalStorageFailure extends Failure {
  const LocalStorageFailure({super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message, super.code});
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({super.message, super.code});
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({super.message, super.code});
}

/// General failures
class UnknownFailure extends Failure {
  const UnknownFailure({super.message, super.code});
}
