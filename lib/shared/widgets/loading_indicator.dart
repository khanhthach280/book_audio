import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Loading indicator widget
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2,
  });
  
  final double size;
  final Color? color;
  final double strokeWidth;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
