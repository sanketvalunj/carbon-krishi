import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const CarbonKrishiApp());
}

class CarbonKrishiApp extends StatelessWidget {
  const CarbonKrishiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarbonKrishi by NexAi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          secondary: const Color(0xFF66BB6A),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// App Constants
class AppColors {
  static const primary = Color(0xFF2E7D32);
  static const secondary = Color(0xFF66BB6A);
  static const accent = Color(0xFF8BC34A);
  static const background = Color(0xFFF1F8E9);
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
  static const text = Color(0xFF212121);
  static const textLight = Color(0xFF757575);
}

class AppStrings {
  static const appName = 'CarbonKrishi';
  static const tagline = 'Grow Green, Earn Green';
  static const byNexAi = 'by NexAi';
}