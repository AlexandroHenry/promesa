import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_locales.dart';

/// Source of locale setting
enum LocaleSource {
  system, // From system/device locale
  api, // From API response
  ip, // From IP-based detection
  manual, // Manually set by user
}

/// Service for handling localization changes
/// Supports changing locale via API or IP-based detection
class LocalizationService {
  static const String _localeKey = 'app_locale';
  static const String _localeSourceKey = 'locale_source';

  /// Change app locale
  static Future<void> changeLocale(
    BuildContext context,
    Locale locale, {
    LocaleSource source = LocaleSource.manual,
  }) async {
    // Check if locale is supported
    if (!AppLocales.supportedLocales.contains(locale)) {
      debugPrint('Locale $locale is not supported, using fallback');
      locale = AppLocales.fallbackLocale;
    }

    // Change locale using easy_localization
    if (context.mounted) {
      await context.setLocale(locale);
    }

    // Save locale preference
    await _saveLocalePreference(locale, source);

    debugPrint('Locale changed to: ${locale.languageCode} (source: $source)');
  }

  /// Get saved locale from preferences
  static Future<Locale?> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);
      
      if (localeCode != null) {
        return AppLocales.fromLanguageCode(localeCode);
      }
    } catch (e) {
      debugPrint('Error loading saved locale: $e');
    }
    
    return null;
  }

  /// Get saved locale source
  static Future<LocaleSource> getSavedLocaleSource() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sourceIndex = prefs.getInt(_localeSourceKey) ?? 0;
      return LocaleSource.values[sourceIndex];
    } catch (e) {
      debugPrint('Error loading saved locale source: $e');
      return LocaleSource.system;
    }
  }

  /// Initialize locale based on saved preference or system locale
  static Future<Locale> initializeLocale() async {
    // First try to get saved locale
    final savedLocale = await getSavedLocale();
    final savedSource = await getSavedLocaleSource();

    if (savedLocale != null && savedSource != LocaleSource.system) {
      debugPrint('Using saved locale: ${savedLocale.languageCode} (source: $savedSource)');
      return savedLocale;
    }

    // Fall back to system locale
    final systemLocale = _getSystemLocale();
    debugPrint('Using system locale: ${systemLocale.languageCode}');
    
    return systemLocale;
  }

  /// Set locale from API response
  /// Example: When server returns preferred language based on user profile
  static Future<void> setLocaleFromAPI(
    BuildContext context,
    String languageCode,
  ) async {
    final locale = AppLocales.fromLanguageCode(languageCode);
    if (locale != null && context.mounted) {
      await changeLocale(context, locale, source: LocaleSource.api);
    }
  }

  /// Set locale from IP-based detection
  /// Example: When detecting country from IP and setting appropriate language
  static Future<void> setLocaleFromIP(
    BuildContext context,
    String countryCode,
  ) async {
    Locale? locale;
    
    // Map country codes to locales
    switch (countryCode.toUpperCase()) {
      case 'KR': // South Korea
        locale = AppLocales.ko;
        break;
      case 'US': // United States
      case 'GB': // United Kingdom
      case 'CA': // Canada
      case 'AU': // Australia
        locale = AppLocales.en;
        break;
      default:
        locale = AppLocales.fallbackLocale;
    }

    if (context.mounted) {
      await changeLocale(context, locale, source: LocaleSource.ip);
    }
  }

  /// Reset to system locale
  static Future<void> resetToSystemLocale(BuildContext context) async {
    final systemLocale = _getSystemLocale();
    if (context.mounted) {
      await changeLocale(context, systemLocale, source: LocaleSource.system);
    }
  }

  /// Get current locale display name
  static String getCurrentLocaleDisplayName(BuildContext context) {
    final currentLocale = context.locale;
    return AppLocales.getLanguageName(currentLocale);
  }

  /// Check if current locale is RTL
  static bool isRTL(BuildContext context) {
    final locale = context.locale;
    // Add RTL languages here (Arabic, Hebrew, etc.)
    final rtlLanguages = ['ar', 'he', 'fa', 'ur'];
    return rtlLanguages.contains(locale.languageCode);
  }

  /// Save locale preference to shared preferences
  static Future<void> _saveLocalePreference(
    Locale locale,
    LocaleSource source,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
      await prefs.setInt(_localeSourceKey, source.index);
    } catch (e) {
      debugPrint('Error saving locale preference: $e');
    }
  }

  /// Get system locale with fallback
  static Locale _getSystemLocale() {
    final systemLocale = PlatformDispatcher.instance.locale;
    
    // Check if system locale is supported
    final supportedLocale = AppLocales.fromLanguageCode(systemLocale.languageCode);
    return supportedLocale ?? AppLocales.fallbackLocale;
  }

  /// Clear saved locale preferences
  static Future<void> clearSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localeKey);
      await prefs.remove(_localeSourceKey);
    } catch (e) {
      debugPrint('Error clearing saved locale: $e');
    }
  }

  /// Reload translations from assets
  /// Useful when translation files are updated
  static Future<void> reloadTranslations(BuildContext context) async {
    try {
      debugPrint('Reloading translations...');
      
      if (!context.mounted) {
        debugPrint('Context not mounted, skipping reload');
        return;
      }
      
      // Get current locale
      final currentLocale = context.locale;
      
      // Reset to fallback locale and then back to current
      // This forces EasyLocalization to reload translations
      await context.setLocale(AppLocales.fallbackLocale);
      
      // Small delay to ensure the change is processed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Check if context is still mounted before continuing
      if (context.mounted) {
        await context.setLocale(currentLocale);
      }
      
      debugPrint('Translations reloaded successfully');
    } catch (e) {
      debugPrint('Error reloading translations: $e');
    }
  }

  /// Force rebuild all widgets using translations
  static void forceTranslationRebuild(BuildContext context) {
    try {
      debugPrint('Forcing translation rebuild...');
      
      if (!context.mounted) {
        debugPrint('Context not mounted, skipping rebuild');
        return;
      }
      
      // Force a locale change to trigger rebuild
      final currentLocale = context.locale;
      context.setLocale(currentLocale);
      
      debugPrint('Translation rebuild completed');
    } catch (e) {
      debugPrint('Error forcing rebuild: $e');
    }
  }

  /// Safe version of reloadTranslations that can be used with any widget
  static Future<void> safeReloadTranslations() async {
    try {
      // This approach doesn't require BuildContext
      await EasyLocalization.ensureInitialized();
      debugPrint('Safe translations reload completed');
    } catch (e) {
      debugPrint('Error in safe reload translations: $e');
    }
  }
}