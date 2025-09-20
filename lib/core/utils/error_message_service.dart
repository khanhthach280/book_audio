import '../../l10n/app_localizations.dart';

/// Service for getting localized error messages
class ErrorMessageService {
  static AppLocalizations? _localizations;
  
  /// Initialize with current localizations
  static void initialize(AppLocalizations localizations) {
    _localizations = localizations;
  }
  
  /// Get localized error message for failure type
  static String getErrorMessage(String failureType) {
    final l10n = _localizations;
    if (l10n == null) {
      // Fallback to English if no localization is set
      return _getEnglishMessage(failureType);
    }
    
    switch (failureType) {
      case 'NoInternetFailure':
        return l10n.noInternet;
      case 'NetworkFailure':
        return l10n.networkError;
      case 'ServerFailure':
        return l10n.serverError;
      case 'TimeoutFailure':
        return l10n.timeoutError;
      case 'InvalidCredentialsFailure':
        return l10n.invalidCredentials;
      case 'AuthFailure':
        return l10n.loginFailed;
      case 'LocalStorageFailure':
        return 'Failed to save data locally.';
      case 'CacheFailure':
        return 'Failed to cache data.';
      case 'UnknownFailure':
        return l10n.error;
      default:
        return l10n.error;
    }
  }
  
  /// Get English error message as fallback
  static String _getEnglishMessage(String failureType) {
    switch (failureType) {
      case 'NoInternetFailure':
        return 'No internet connection. Please check your network.';
      case 'NetworkFailure':
        return 'Network error. Please try again.';
      case 'ServerFailure':
        return 'Server error. Please try again later.';
      case 'TimeoutFailure':
        return 'Request timeout. Please try again.';
      case 'InvalidCredentialsFailure':
        return 'Invalid credentials. Please check your login details.';
      case 'AuthFailure':
        return 'Authentication failed. Please try again.';
      case 'LocalStorageFailure':
        return 'Failed to save data locally.';
      case 'CacheFailure':
        return 'Failed to cache data.';
      case 'UnknownFailure':
        return 'An unexpected error occurred.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
