import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'app_colors.dart';

/// Custom color scheme for the app
class CustomColorScheme {
  final Color primary;
  final Color secondary;
  final Color accent;
  final String name;
  
  const CustomColorScheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.name,
  });
  
  /// Default color scheme
  static const CustomColorScheme defaultScheme = CustomColorScheme(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    accent: AppColors.accent,
    name: 'Default',
  );
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'primary': primary.value,
      'secondary': secondary.value,
      'accent': accent.value,
      'name': name,
    };
  }
  
  /// Create from JSON
  factory CustomColorScheme.fromJson(Map<String, dynamic> json) {
    return CustomColorScheme(
      primary: Color(json['primary'] as int),
      secondary: Color(json['secondary'] as int),
      accent: Color(json['accent'] as int),
      name: json['name'] as String? ?? 'Custom',
    );
  }
  
  /// Copy with new values
  CustomColorScheme copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    String? name,
  }) {
    return CustomColorScheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      name: name ?? this.name,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomColorScheme &&
        other.primary == primary &&
        other.secondary == secondary &&
        other.accent == accent &&
        other.name == name;
  }
  
  @override
  int get hashCode => Object.hash(primary, secondary, accent, name);
}

/// Predefined color schemes
class PredefinedColorSchemes {
  static const List<CustomColorScheme> schemes = [
    // Default theme
    CustomColorScheme(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      accent: AppColors.accent,
      name: 'Default',
    ),
    // Blue theme
    CustomColorScheme(
      primary: Color(0xFF2196F3),
      secondary: Color(0xFF03DAC6),
      accent: Color(0xFFFF9800),
      name: 'Blue',
    ),
    // Green theme
    CustomColorScheme(
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFF8BC34A),
      accent: Color(0xFFFFC107),
      name: 'Green',
    ),
    // Purple theme
    CustomColorScheme(
      primary: Color(0xFF9C27B0),
      secondary: Color(0xFFE91E63),
      accent: Color(0xFFFF5722),
      name: 'Purple',
    ),
    // Orange theme
    CustomColorScheme(
      primary: Color(0xFFFF9800),
      secondary: Color(0xFFFF5722),
      accent: Color(0xFF4CAF50),
      name: 'Orange',
    ),
    // Teal theme
    CustomColorScheme(
      primary: Color(0xFF009688),
      secondary: Color(0xFF00BCD4),
      accent: Color(0xFFFF9800),
      name: 'Teal',
    ),
    // Indigo theme
    CustomColorScheme(
      primary: Color(0xFF3F51B5),
      secondary: Color(0xFF2196F3),
      accent: Color(0xFF00BCD4),
      name: 'Indigo',
    ),
    // Red theme
    CustomColorScheme(
      primary: Color(0xFFF44336),
      secondary: Color(0xFFE91E63),
      accent: Color(0xFFFF9800),
      name: 'Red',
    ),
  ];
}

/// Color scheme provider
final colorSchemeProvider = StateNotifierProvider<ColorSchemeNotifier, CustomColorScheme>((ref) {
  return ColorSchemeNotifier();
});

/// Color scheme notifier for state management
class ColorSchemeNotifier extends StateNotifier<CustomColorScheme> {
  ColorSchemeNotifier() : super(CustomColorScheme.defaultScheme) {
    _loadColorScheme();
  }
  
  /// Load saved color scheme from SharedPreferences
  Future<void> _loadColorScheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final primaryValue = prefs.getInt('${AppConstants.themeKey}_primary');
      final secondaryValue = prefs.getInt('${AppConstants.themeKey}_secondary');
      final accentValue = prefs.getInt('${AppConstants.themeKey}_accent');
      final name = prefs.getString('${AppConstants.themeKey}_name');
      
      if (primaryValue != null && secondaryValue != null && accentValue != null) {
        state = CustomColorScheme(
          primary: Color(primaryValue),
          secondary: Color(secondaryValue),
          accent: Color(accentValue),
          name: name ?? 'Custom',
        );
      }
    } catch (e) {
      // If loading fails, use default colors
      state = CustomColorScheme.defaultScheme;
    }
  }
  
  /// Set color scheme and save to SharedPreferences
  Future<void> setColorScheme(CustomColorScheme colorScheme) async {
    state = colorScheme;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('${AppConstants.themeKey}_primary', colorScheme.primary.value);
      await prefs.setInt('${AppConstants.themeKey}_secondary', colorScheme.secondary.value);
      await prefs.setInt('${AppConstants.themeKey}_accent', colorScheme.accent.value);
      await prefs.setString('${AppConstants.themeKey}_name', colorScheme.name);
    } catch (e) {
      // If saving fails, continue with the current state
      print('Failed to save color scheme: $e');
    }
  }
  
  /// Set individual color
  Future<void> setPrimaryColor(Color color) async {
    final newScheme = state.copyWith(primary: color, name: 'Custom');
    await setColorScheme(newScheme);
  }
  
  /// Set secondary color
  Future<void> setSecondaryColor(Color color) async {
    final newScheme = state.copyWith(secondary: color, name: 'Custom');
    await setColorScheme(newScheme);
  }
  
  /// Set accent color
  Future<void> setAccentColor(Color color) async {
    final newScheme = state.copyWith(accent: color, name: 'Custom');
    await setColorScheme(newScheme);
  }
  
  /// Reset to default colors
  Future<void> resetToDefault() async {
    await setColorScheme(CustomColorScheme.defaultScheme);
  }
  
  /// Apply predefined color scheme
  Future<void> applyPredefinedScheme(CustomColorScheme scheme) async {
    await setColorScheme(scheme);
  }
}
