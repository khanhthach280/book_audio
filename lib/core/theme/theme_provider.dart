import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'app_theme.dart';
import 'color_scheme_provider.dart';

/// Theme mode provider for managing app theme
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Theme mode notifier for state management
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
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
            state = ThemeMode.light;
            break;
          case 'dark':
            state = ThemeMode.dark;
            break;
          case 'system':
          default:
            state = ThemeMode.system;
            break;
        }
      }
    } catch (e) {
      // If loading fails, use system theme
      state = ThemeMode.system;
    }
  }
  
  /// Set theme mode and save to SharedPreferences
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      String themeModeString;
      
      switch (mode) {
        case ThemeMode.light:
          themeModeString = 'light';
          break;
        case ThemeMode.dark:
          themeModeString = 'dark';
          break;
        case ThemeMode.system:
          themeModeString = 'system';
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
    if (state == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }
}

/// Light theme data provider with custom colors
final lightThemeDataProvider = Provider<ThemeData>((ref) {
  final colorScheme = ref.watch(colorSchemeProvider);
  return AppTheme.createLightTheme(colorScheme);
});

/// Dark theme data provider with custom colors
final darkThemeDataProvider = Provider<ThemeData>((ref) {
  final colorScheme = ref.watch(colorSchemeProvider);
  return AppTheme.createDarkTheme(colorScheme);
});

/// Theme data provider based on current theme mode
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  final lightTheme = ref.watch(lightThemeDataProvider);
  final darkTheme = ref.watch(darkThemeDataProvider);
  
  switch (themeMode) {
    case ThemeMode.light:
      return lightTheme;
    case ThemeMode.dark:
      return darkTheme;
    case ThemeMode.system:
      return lightTheme; // Default to light theme
  }
});

