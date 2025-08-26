import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Emerald
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF34D399);
  
  // Accent Colors
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentDark = Color(0xFFD97706);
  static const Color accentLight = Color(0xFFFBBF24);
  
  // Error Colors
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFF87171);
  
  // Warning Colors
  static const Color warning = Color(0xFFF97316); // Orange
  static const Color warningDark = Color(0xFFEA580C);
  static const Color warningLight = Color(0xFFFB923C);
  
  // Success Colors
  static const Color success = Color(0xFF22C55E); // Green
  static const Color successDark = Color(0xFF16A34A);
  static const Color successLight = Color(0xFF4ADE80);
  
  // Info Colors
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoDark = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFF60A5FA);
  
  // Neutral Colors - Light Theme
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color lightOnBackground = Color(0xFF1A1A1A);
  static const Color lightOnSurface = Color(0xFF1A1A1A);
  static const Color lightOnSurfaceVariant = Color(0xFF6B7280);
  static const Color lightOutline = Color(0xFFE5E7EB);
  static const Color lightOutlineVariant = Color(0xFFF3F4F6);
  
  // Neutral Colors - Dark Theme
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceVariant = Color(0xFF262626);
  static const Color darkOnBackground = Color(0xFFF5F5F5);
  static const Color darkOnSurface = Color(0xFFF5F5F5);
  static const Color darkOnSurfaceVariant = Color(0xFF9CA3AF);
  static const Color darkOutline = Color(0xFF374151);
  static const Color darkOutlineVariant = Color(0xFF1F2937);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);
  
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);
  static const Color textDisabledDark = Color(0xFF6B7280);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark],
  );
  
  // Shadow Colors
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowDark = Color(0x1F000000);
}

// 색상 확장 메서드
extension AppColorsExtension on ColorScheme {
  Color get success => brightness == Brightness.light 
      ? AppColors.success 
      : AppColors.successLight;
  
  Color get warning => brightness == Brightness.light 
      ? AppColors.warning 
      : AppColors.warningLight;
  
  Color get info => brightness == Brightness.light 
      ? AppColors.info 
      : AppColors.infoLight;
  
  Color get textPrimary => brightness == Brightness.light 
      ? AppColors.textPrimary 
      : AppColors.textPrimaryDark;
  
  Color get textSecondary => brightness == Brightness.light 
      ? AppColors.textSecondary 
      : AppColors.textSecondaryDark;
  
  Color get textTertiary => brightness == Brightness.light 
      ? AppColors.textTertiary 
      : AppColors.textTertiaryDark;
}
