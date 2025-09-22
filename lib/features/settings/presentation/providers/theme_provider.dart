import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import 'color_scheme_provider.dart';

/// Custom theme mode enum for 3 types: light, dark, custom
enum AppThemeMode {
  light,   // Fixed light theme
  dark,    // Fixed dark theme  
  custom,  // Customizable theme with color picker
}

/// Theme mode provider for managing app theme
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

/// Theme mode notifier for state management
class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier() : super(AppThemeMode.light) {
    _loadThemeMode();
  }

  /// Load saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(AppConstants.themeKey);

      if (themeModeString != null) {
        switch (themeModeString) {
          case 'light':
            state = AppThemeMode.light;
            break;
          case 'dark':
            state = AppThemeMode.dark;
            break;
          case 'custom':
            state = AppThemeMode.custom;
            break;
          default:
            state = AppThemeMode.light; // Default to light
            break;
        }
      }
    } catch (e) {
      // If loading fails, use light theme as default
      state = AppThemeMode.light;
    }
  }

  /// Set theme mode and save to SharedPreferences
  Future<void> setThemeMode(AppThemeMode mode) async {
    state = mode;

    try {
      final prefs = await SharedPreferences.getInstance();
      String themeModeString;

      switch (mode) {
        case AppThemeMode.light:
          themeModeString = 'light';
          break;
        case AppThemeMode.dark:
          themeModeString = 'dark';
          break;
        case AppThemeMode.custom:
          themeModeString = 'custom';
          break;
      }

      await prefs.setString(AppConstants.themeKey, themeModeString);
    } catch (e) {
      // If saving fails, continue with the current state
      print('Failed to save theme mode: $e');
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (state == AppThemeMode.light) {
      await setThemeMode(AppThemeMode.dark);
    } else {
      await setThemeMode(AppThemeMode.light);
    }
  }
}

/// Light theme data provider with custom colors (for custom mode only)
final lightThemeDataProvider = Provider<ThemeData>((ref) {
  final colorScheme = ref.watch(colorSchemeProvider);
  return AppTheme.createLightTheme(colorScheme);
});

/// Dark theme data provider with custom colors (for custom mode only)
final darkThemeDataProvider = Provider<ThemeData>((ref) {
  final colorScheme = ref.watch(colorSchemeProvider);
  return AppTheme.createDarkTheme(colorScheme);
});

/// Fixed light theme provider (for light mode)
final fixedLightThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.lightTheme;
});

/// Fixed dark theme provider (for dark mode)
final fixedDarkThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.darkTheme;
});

/// Theme data provider based on current theme mode
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  final fixedLightTheme = ref.watch(fixedLightThemeProvider);
  final fixedDarkTheme = ref.watch(fixedDarkThemeProvider);
  final customLightTheme = ref.watch(lightThemeDataProvider);

  switch (themeMode) {
    case AppThemeMode.light:
      return fixedLightTheme; // Fixed light theme - never changes
    case AppThemeMode.dark:
      return fixedDarkTheme; // Fixed dark theme - never changes
    case AppThemeMode.custom:
      return customLightTheme; // Custom theme with customizable colors
  }
});

/// Convert AppThemeMode to Flutter's ThemeMode for MaterialApp
final flutterThemeModeProvider = Provider<ThemeMode>((ref) {
  final appThemeMode = ref.watch(themeModeProvider);
  
  switch (appThemeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.custom:
      return ThemeMode.light; // Custom mode uses light as base
  }
});
