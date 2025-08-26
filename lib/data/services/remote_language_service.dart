import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/localization/localization.dart';

/// Service for handling language changes from external sources
class RemoteLanguageService {
  final Dio _dio;

  RemoteLanguageService(this._dio);

  /// Fetch user's preferred language from API
  /// Example: GET /api/user/preferences
  Future<void> fetchAndSetUserLanguage(
    BuildContext context,
    String userId,
  ) async {
    try {
      debugPrint('Fetching user language preference from API...');
      
      final response = await _dio.get('/api/user/preferences/$userId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        final languageCode = data['language'] as String?;
        
        if (languageCode != null && languageCode.isNotEmpty) {
          await LocalizationService.setLocaleFromAPI(context, languageCode);
          debugPrint('Language set from API: $languageCode');
        }
      }
    } catch (e) {
      debugPrint('Error fetching user language from API: $e');
      // Fall back to system locale on error
      await LocalizationService.resetToSystemLocale(context);
    }
  }

  /// Update user's language preference to API
  /// Example: PUT /api/user/preferences
  Future<bool> updateUserLanguage(
    String userId,
    String languageCode,
  ) async {
    try {
      debugPrint('Updating user language preference to API: $languageCode');
      
      final response = await _dio.put(
        '/api/user/preferences/$userId',
        data: {'language': languageCode},
      );
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating user language to API: $e');
      return false;
    }
  }

  /// Detect language from IP address using geolocation service
  /// Example: Using ipapi.co or similar service
  Future<void> detectAndSetLanguageFromIP(BuildContext context) async {
    try {
      debugPrint('Detecting language from IP address...');
      
      // Using ipapi.co as an example (you can use any IP geolocation service)
      final response = await _dio.get('https://ipapi.co/json/');
      
      if (response.statusCode == 200) {
        final data = response.data;
        final countryCode = data['country_code'] as String?;
        
        if (countryCode != null && countryCode.isNotEmpty) {
          await LocalizationService.setLocaleFromIP(context, countryCode);
          debugPrint('Language set from IP detection. Country: $countryCode');
        }
      }
    } catch (e) {
      debugPrint('Error detecting language from IP: $e');
      // Fall back to system locale on error
      await LocalizationService.resetToSystemLocale(context);
    }
  }

  /// Detect language from custom API that determines locale based on various factors
  /// Example: Combining user profile, IP, browser settings, etc.
  Future<void> detectLanguageFromCustomAPI(
    BuildContext context, {
    String? userId,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      debugPrint('Detecting language from custom API...');
      
      final savedLocale = await LocalizationService.getSavedLocale();
      final params = <String, dynamic>{
        if (userId != null) 'user_id': userId,
        'current_locale': context.locale.languageCode,
        'device_locale': savedLocale?.languageCode ?? 'unknown',
        ...?additionalParams,
      };

      final response = await _dio.post(
        '/api/detect-language',
        data: params,
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final recommendedLanguage = data['recommended_language'] as String?;
        final confidence = data['confidence'] as double?;
        
        if (recommendedLanguage != null && 
            recommendedLanguage.isNotEmpty && 
            (confidence ?? 0) > 0.7) {
          await LocalizationService.setLocaleFromAPI(context, recommendedLanguage);
          debugPrint('Language set from custom API: $recommendedLanguage (confidence: $confidence)');
        }
      }
    } catch (e) {
      debugPrint('Error detecting language from custom API: $e');
    }
  }

  /// Set language with automatic API sync
  /// This method changes the locale locally and syncs with API
  Future<void> setLanguageWithSync(
    BuildContext context,
    String languageCode, {
    String? userId,
  }) async {
    try {
      // First, change locale locally
      final locale = AppLocales.fromLanguageCode(languageCode);
      if (locale != null) {
        await LocalizationService.changeLocale(
          context, 
          locale,
          source: LocaleSource.manual,
        );
        
        // Then sync with API if user is logged in
        if (userId != null) {
          final success = await updateUserLanguage(userId, languageCode);
          if (success) {
            debugPrint('Language preference synced with API successfully');
          } else {
            debugPrint('Failed to sync language preference with API');
          }
        }
      }
    } catch (e) {
      debugPrint('Error setting language with sync: $e');
    }
  }
}

/// Extension for easy access to RemoteLanguageService
extension RemoteLanguageServiceExt on BuildContext {
  /// Quick access to set language from API response
  Future<void> setLanguageFromAPI(String languageCode) async {
    await LocalizationService.setLocaleFromAPI(this, languageCode);
  }

  /// Quick access to set language from IP detection
  Future<void> setLanguageFromIP(String countryCode) async {
    await LocalizationService.setLocaleFromIP(this, countryCode);
  }
}