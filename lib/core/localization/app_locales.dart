import 'dart:ui';

/// Supported locales for the application
class AppLocales {
  AppLocales._();

  /// English locale
  static const Locale en = Locale('en');

  /// Korean locale
  static const Locale ko = Locale('ko');

  /// List of supported locales
  static const List<Locale> supportedLocales = [
    en,
    ko,
  ];

  /// Default fallback locale
  static const Locale fallbackLocale = en;

  /// Get locale from language code
  static Locale? fromLanguageCode(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return en;
      case 'ko':
        return ko;
      default:
        return null;
    }
  }

  /// Get language name from locale
  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ko':
        return '한국어';
      default:
        return locale.languageCode;
    }
  }
}