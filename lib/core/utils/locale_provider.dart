import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Supported locales
const List<Locale> supportedLocales = [Locale('en', 'US'), Locale('vi', 'VN')];

/// Locale provider for managing app language
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Locale notifier for state management
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('vi', 'VN')) {
    _loadLocale();
  }

  /// Load saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeString = prefs.getString(AppConstants.languageKey);

      if (localeString != null) {
        final parts = localeString.split('_');
        final locale = parts.length > 1
            ? Locale(parts[0], parts[1])
            : Locale(parts[0]);

        if (supportedLocales.contains(locale)) {
          state = locale;
        } else {
          state = const Locale('vi', 'VN'); // default
        }
      } else {
        state = const Locale('vi', 'VN'); // default
      }
    } catch (e) {
      print('Failed to load locale: $e');
      state = const Locale('vi', 'VN'); // default
    }
  }

  /// Set locale and save to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    if (supportedLocales.contains(locale)) {
      state = locale;

      try {
        final prefs = await SharedPreferences.getInstance();
        final localeString = locale.countryCode != null
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode;

        await prefs.setString(AppConstants.languageKey, localeString);
        print('Locale saved: $localeString');
      } catch (e) {
        print('Failed to save locale: $e');
      }
    } else {
      print('Unsupported locale: ${locale.languageCode}_${locale.countryCode}');
    }
  }

  /// Toggle between English and Vietnamese
  Future<void> toggleLanguage() async {
    if (state.languageCode == 'vi') {
      await setLocale(const Locale('en', 'US'));
    } else {
      await setLocale(const Locale('vi', 'VN'));
    }
  }

  /// Get current language name
  String get currentLanguageName {
    switch (state.languageCode) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      default:
        return 'Tiếng Việt'; // Default to Vietnamese
    }
  }

  /// Check if current locale is Vietnamese
  bool get isVietnamese => state.languageCode == 'vi';

  /// Check if current locale is English
  bool get isEnglish => state.languageCode == 'en';
}
