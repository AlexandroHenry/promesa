import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // 기본 폰트 패밀리 (한글 지원)
  static const String _primaryFontFamily = 'Pretendard';
  static const String _secondaryFontFamily = 'Inter';

  // Google Fonts 사용 (인터넷 연결시)
  static TextTheme _getGoogleFontsTextTheme() {
    try {
      // Pretendard는 Google Fonts에서 지원되지 않으므로 Noto Sans KR 사용
      return GoogleFonts.notoSansKrTextTheme();
    } catch (e) {
      // Google Fonts 로드 실패시 fallback
      return _getFallbackTextTheme();
    }
  }

  // Fallback 텍스트 테마 (로컬 폰트)
  static TextTheme _getFallbackTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      ),
      headlineLarge: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
      ),
      titleLarge: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  // Light Theme Typography
  static TextTheme get lightTextTheme {
    final baseTheme = _getGoogleFontsTextTheme();
    return baseTheme.apply(
      bodyColor: const Color(0xFF1A1A1A),
      displayColor: const Color(0xFF1A1A1A),
    );
  }

  // Dark Theme Typography
  static TextTheme get darkTextTheme {
    final baseTheme = _getGoogleFontsTextTheme();
    return baseTheme.apply(
      bodyColor: const Color(0xFFF9FAFB),
      displayColor: const Color(0xFFF9FAFB),
    );
  }

  // 커스텀 텍스트 스타일들
  static const TextStyle caption = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.6,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.6,
  );

  // 폰트 가중치
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // 라인 높이
  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;

  // 레터 스페이싱
  static const double letterSpacingTight = -0.25;
  static const double letterSpacingNormal = 0;
  static const double letterSpacingWide = 0.5;
}

// 텍스트 테마 확장
extension AppTextThemeExtension on TextTheme {
  TextStyle get caption => AppTypography.caption;
  TextStyle get overline => AppTypography.overline;
  
  // 강조 스타일
  TextStyle get bodyLargeBold => bodyLarge!.copyWith(fontWeight: AppTypography.bold);
  TextStyle get bodyMediumBold => bodyMedium!.copyWith(fontWeight: AppTypography.bold);
  TextStyle get bodySmallBold => bodySmall!.copyWith(fontWeight: AppTypography.bold);
  
  // 보조 색상 스타일
  TextStyle get bodyLargeSecondary => bodyLarge!.copyWith(color: const Color(0xFF6B7280));
  TextStyle get bodyMediumSecondary => bodyMedium!.copyWith(color: const Color(0xFF6B7280));
  TextStyle get bodySmallSecondary => bodySmall!.copyWith(color: const Color(0xFF6B7280));
}
