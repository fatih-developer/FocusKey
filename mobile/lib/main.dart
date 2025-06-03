import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Uygulamanın yönlendirmesini dikey olarak kilitle
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Veritabanını başlat
  try {
    final dbService = DatabaseService();
    await dbService.database; // Veritabanı bağlantısını başlat

  } catch (e) {
    rethrow;
  }
  
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
      light: AppTheme.light,
      dark: AppTheme.dark,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'FocusKey',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map?;
            final userId = args?['userId'] as int?;
            return HomeScreen(
              userId: userId ?? 0,
              logout: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            );
          }
        },
      ),
    );
  }
}
