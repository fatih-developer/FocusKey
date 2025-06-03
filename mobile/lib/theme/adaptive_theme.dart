import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

/// Uygulama genelinde tema yönetimi için yardımcı sınıf
class AppThemeManager {
  /// Mevcut tema modunu döndürür
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Tema modunu değiştirir
  static void toggleTheme(BuildContext context) {
    final theme = AdaptiveTheme.of(context);
    if (theme.mode == AdaptiveThemeMode.light) {
      theme.setDark();
    } else {
      theme.setLight();
    }
  }

  /// Sistem temasını kullan
  static void useSystemTheme(BuildContext context) {
    AdaptiveTheme.of(context).setSystem();
  }

  /// Tema değişikliğini dinle
  static ValueNotifier<ThemeMode> themeChangeNotifier(BuildContext context) {
    final theme = AdaptiveTheme.of(context);
    return ValueNotifier<ThemeMode>(
      theme.mode == AdaptiveThemeMode.dark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

/// Tema değişikliklerini dinlemek için bir widget
class ThemeListener extends StatelessWidget {
  final Widget Function(BuildContext context, ThemeMode themeMode) builder;

  const ThemeListener({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeManager.themeChangeNotifier(context),
      builder: (context, themeMode, _) {
        return builder(context, themeMode);
      },
    );
  }
}
