import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Kaydedilmiş tema modunu yükle
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  
  const MyApp({
    super.key,
    this.savedThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
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
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: LightColors.primary,
          foregroundColor: LightColors.onPrimary,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: LightColors.primary,
            foregroundColor: LightColors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      dark: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: DarkColors.primary,
          secondary: DarkColors.secondary,
          surface: DarkColors.surface,
          surfaceContainerHighest: DarkColors.background,
          onPrimary: DarkColors.onPrimary,
          onSecondary: DarkColors.onSecondary,
          onSurface: DarkColors.onSurface,
          onSurfaceVariant: DarkColors.onBackground,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: DarkColors.primary,
          foregroundColor: DarkColors.onPrimary,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
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
          ),
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'FocusKey',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusKey'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              AdaptiveTheme.of(context).toggleThemeMode();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hoş Geldiniz',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tema değiştirme işlevi
                AdaptiveTheme.of(context).toggleThemeMode();
              },
              child: Text(
                'Temayı Değiştir',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
