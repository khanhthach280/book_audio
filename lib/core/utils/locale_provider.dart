import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Supported locales
const List<Locale> supportedLocales = [
  Locale('en', 'US'),
  Locale('vi', 'VN'),
];

/// Locale provider for managing app language
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Locale notifier for state management
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en', 'US')) {
    _loadLocale();
  }
  
  /// Load saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(AppConstants.languageKey);
      
      if (languageCode != null) {
        final locale = Locale(languageCode);
        if (supportedLocales.contains(locale)) {
          state = locale;
        }
      }
    } catch (e) {
      // If loading fails, use default locale
      state = const Locale('en', 'US');
    }
  }
  
  /// Set locale and save to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    if (supportedLocales.contains(locale)) {
      state = locale;
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.languageKey, locale.languageCode);
      } catch (e) {
        // If saving fails, continue with the current state
        print('Failed to save locale: $e');
      }
    }
  }
  
  /// Toggle between English and Vietnamese
  Future<void> toggleLanguage() async {
    if (state.languageCode == 'en') {
      await setLocale(const Locale('vi', 'VN'));
    } else {
      await setLocale(const Locale('en', 'US'));
    }
  }
  
  /// Get current language name
  String get currentLanguageName {
    switch (state.languageCode) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
      default:
        return 'English';
    }
  }
  
  /// Check if current locale is Vietnamese
  bool get isVietnamese => state.languageCode == 'vi';
  
  /// Check if current locale is English
  bool get isEnglish => state.languageCode == 'en';
}
