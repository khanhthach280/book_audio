import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../errors/failures.dart';
import '../theme/app_colors.dart';

/// Error handler utility class
class ErrorHandler {
  /// Show error snackbar
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: duration,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: AppColors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
  
  /// Show success snackbar
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: duration,
      ),
    );
  }
  
  /// Show info snackbar
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.info,
        duration: duration,
      ),
    );
  }
  
  /// Show error dialog
  static void showErrorDialog(
    BuildContext context,
    String title,
    String message, {
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: onPressed ?? () => Navigator.of(context).pop(),
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }
  
  /// Get error message from failure
  static String getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NoInternetFailure:
        return 'No internet connection. Please check your network.';
      case NetworkFailure:
        return 'Network error. Please try again.';
      case ServerFailure:
        return 'Server error. Please try again later.';
      case TimeoutFailure:
        return 'Request timeout. Please try again.';
      case InvalidCredentialsFailure:
        return 'Invalid credentials. Please check your login details. ===== khanh 1';
      case AuthFailure:
        return 'Authentication failed. Please try again';
      case LocalStorageFailure:
        return 'Failed to save data locally.';
      case CacheFailure:
        return 'Failed to cache data.';
      default:
        return failure.message ?? 'An unexpected error occurred.';
    }
  }
  
  /// Get localized error message
  static String getLocalizedErrorMessage(
    BuildContext context,
    Failure failure,
  ) {
    // This would typically use localization
    return getErrorMessage(failure);
  }
}

/// Error handler provider
final errorHandlerProvider = Provider<ErrorHandler>((ref) {
  return ErrorHandler();
});
