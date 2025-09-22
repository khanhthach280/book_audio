import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../errors/failures.dart';
import '../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'error_message_service.dart';

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
  
  /// Get error message from failure with localization
  static String getErrorMessage(BuildContext context, Failure failure) {
    // Initialize ErrorMessageService with current context
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      ErrorMessageService.initialize(localizations);
    }
    
    // Get localized message using ErrorMessageService
    return ErrorMessageService.getErrorMessage(failure.runtimeType.toString());
  }
  
  /// Get localized error message (alias for getErrorMessage)
  static String getLocalizedErrorMessage(
    BuildContext context,
    Failure failure,
  ) {
    return getErrorMessage(context, failure);
  }
}

/// Error handler provider
final errorHandlerProvider = Provider<ErrorHandler>((ref) {
  return ErrorHandler();
});
