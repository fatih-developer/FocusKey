import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Açık tema
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: LightColors.primary,
        secondary: LightColors.secondary,
        surface: LightColors.surface,
        surfaceContainerHighest: LightColors.background,
        onPrimary: LightColors.onPrimary,
        onSecondary: LightColors.onSecondary,
        onSurface: LightColors.onSurface,
        onSurfaceVariant: LightColors.onBackground,
        error: LightColors.error,
        onError: LightColors.onError,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: LightColors.primary,
        foregroundColor: LightColors.onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: LightColors.onPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: LightColors.onPrimary),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        color: LightColors.surface,
        shadowColor: AppColors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LightColors.primary,
          foregroundColor: LightColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: LightColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: LightColors.error, width: 1.5),
        ),
        filled: true,
        fillColor: LightColors.surface,
      ),
    );
  }

  // Koyu tema
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: DarkColors.primary,
        secondary: DarkColors.secondary,
        surface: DarkColors.surface,
        surfaceContainerHighest: DarkColors.background,
        onPrimary: DarkColors.onPrimary,
        onSecondary: DarkColors.onSecondary,
        onSurface: DarkColors.onSurface,
        onSurfaceVariant: DarkColors.onBackground,
        error: DarkColors.error,
        onError: DarkColors.onError,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DarkColors.primary,
        foregroundColor: DarkColors.onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: const Color.fromARGB(255, 255, 251, 251),
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: DarkColors.onSurface),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: DarkColors.onSurface),
        displaySmall: AppTextStyles.displaySmall.copyWith(color: DarkColors.onSurface),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: DarkColors.onSurface),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: DarkColors.onSurface),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: DarkColors.onSurface),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: DarkColors.onSurface),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: DarkColors.onSurface),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: DarkColors.onSurface),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: DarkColors.onSurface),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: DarkColors.onSurface),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: DarkColors.onSurface),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: DarkColors.onSurface),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: DarkColors.onSurface),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: DarkColors.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DarkColors.secondary,
          foregroundColor: DarkColors.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DarkColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DarkColors.error),
        ),
      ),
    );
  }
}
