import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'app_locales.dart';

/// Utility class for managing translation updates
class TranslationManager {
  
  /// Reload translations from assets
  /// This is useful when translation files are updated remotely or locally
  static Future<void> reloadTranslations(BuildContext context) async {
    try {
      debugPrint('Reloading translations...');
      
      // Get current locale
      final currentLocale = context.locale;
      
      // Force reload by switching locales
      if (currentLocale != AppLocales.fallbackLocale) {
        await context.setLocale(AppLocales.fallbackLocale);
        await Future.delayed(const Duration(milliseconds: 100));
        if (context.mounted) {
          await context.setLocale(currentLocale);
        }
      } else {
        // If already using fallback locale, switch to another and back
        final alternativeLocale = AppLocales.supportedLocales
            .firstWhere((locale) => locale != AppLocales.fallbackLocale);
        await context.setLocale(alternativeLocale);
        await Future.delayed(const Duration(milliseconds: 100));
        if (context.mounted) {
          await context.setLocale(currentLocale);
        }
      }
      
      debugPrint('Translations reloaded successfully');
    } catch (e) {
      debugPrint('Error reloading translations: $e');
    }
  }

  /// Reset and reload EasyLocalization
  /// This is a more aggressive approach that resets everything
  static Future<void> resetAndReload(BuildContext context) async {
    try {
      debugPrint('Resetting and reloading EasyLocalization...');
      
      final currentLocale = context.locale;
      
      // Reset to system locale first
      await context.resetLocale();
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Check if context is still mounted before continuing
      if (context.mounted) {
        // Then set back to desired locale
        await context.setLocale(currentLocale);
      }
      
      debugPrint('EasyLocalization reset and reloaded successfully');
    } catch (e) {
      debugPrint('Error resetting EasyLocalization: $e');
    }
  }

  /// Force rebuild all widgets using translations
  static void forceRebuild(BuildContext context) {
    try {
      debugPrint('Forcing translation rebuild...');
      
      // Trigger a rebuild by setting the same locale
      final currentLocale = context.locale;
      context.setLocale(currentLocale);
      
      debugPrint('Translation rebuild completed');
    } catch (e) {
      debugPrint('Error forcing rebuild: $e');
    }
  }

  /// Check if translations are loaded
  static bool areTranslationsLoaded(BuildContext context) {
    try {
      // Try to get a translation to check if loaded
      final testTranslation = tr('common.ok');
      return testTranslation.isNotEmpty && testTranslation != 'common.ok';
    } catch (e) {
      debugPrint('Error checking if translations are loaded: $e');
      return false;
    }
  }

  /// Get available locales
  static List<Locale> getAvailableLocales(BuildContext context) {
    return context.supportedLocales;
  }

  /// Get current locale
  static Locale getCurrentLocale(BuildContext context) {
    return context.locale;
  }

  /// Check if a specific locale is supported
  static bool isLocaleSupported(Locale locale) {
    return AppLocales.supportedLocales.contains(locale);
  }

  /// Get fallback locale
  static Locale getFallbackLocale() {
    return AppLocales.fallbackLocale;
  }

  /// Switch to next available locale (useful for testing)
  static Future<void> switchToNextLocale(BuildContext context) async {
    try {
      final currentLocale = context.locale;
      final supportedLocales = AppLocales.supportedLocales;
      
      final currentIndex = supportedLocales.indexOf(currentLocale);
      final nextIndex = (currentIndex + 1) % supportedLocales.length;
      final nextLocale = supportedLocales[nextIndex];
      
      if (context.mounted) {
        await context.setLocale(nextLocale);
      }
      
      debugPrint('Switched to locale: ${nextLocale.languageCode}');
    } catch (e) {
      debugPrint('Error switching to next locale: $e');
    }
  }

  /// Load custom translation data (for dynamic translations)
  static Future<void> loadCustomTranslations(
    BuildContext context,
    Map<String, dynamic> translations, {
    Locale? targetLocale,
  }) async {
    try {
      debugPrint('Loading custom translations...');
      
      // Note: EasyLocalization doesn't support runtime translation loading
      // This is a placeholder for potential future functionality
      // You would need to implement custom translation loading logic here
      
      debugPrint('Custom translations loaded (placeholder)');
    } catch (e) {
      debugPrint('Error loading custom translations: $e');
    }
  }
}