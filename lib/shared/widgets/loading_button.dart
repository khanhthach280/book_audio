import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Loading button widget with loading state
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.minimumSize,
    this.shape,
  });
  
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final OutlinedBorder? shape;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: foregroundColor ?? AppColors.white,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        minimumSize: minimumSize ?? const Size(double.infinity, 48),
        shape: shape ?? RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: foregroundColor ?? AppColors.white,
                strokeWidth: 2,
              ),
            )
          : child,
    );
  }
}
