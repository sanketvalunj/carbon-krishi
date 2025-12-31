import 'package:flutter/material.dart';

class AppTheme {
  static const Color successLight = Color(0xFF4CAF50);
  static const Color errorLight = Color(0xFFF44336);
  static const Color warningLight = Color(0xFFFF9800);

  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textDisabledLight = Color(0xFFBDBDBD);
  static ThemeData get lightTheme {
    return ThemeData(
      // 🔴 IMPORTANT: keep Material 2 for stability
      useMaterial3: false,

      // 🌱 Brand colors
      primarySwatch: Colors.green,
      primaryColor: const Color(0xFF2E7D32),

      // 🧱 Background
      scaffoldBackgroundColor: Colors.white,

      // 🧾 Font
      fontFamily: 'Roboto',

      // 🎨 Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2E7D32),
        secondary: const Color(0xFF66BB6A),
        brightness: Brightness.light,
      ),

      // 🧠 TEXT VISIBILITY FIX (VERY IMPORTANT)
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black54),
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black),
      ),

      // 🟢 AppBar FIX
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // 🧩 TextField / Form FIX
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.black),
      ),

      // 🧱 Card FIX (Dashboard, Stats, etc.)
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // 🟢 Button FIX
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
