import 'package:flutter/material.dart';

abstract final class ShopColors {
  static const background = Color(0xFFF5F6FA);
  static const tile = Color(0xFFECECF2);
  static const purple = Color(0xFF6554FF);
  static const lavender = Color(0xFF8D82FF);
  static const muted = Color(0xFFAEAEBF);
  static const pink = Color(0xFFFF58A5);
  static const ink = Color(0xFF141414);
  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purple, lavender],
  );
}

ThemeData shopTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'Avenir',
  scaffoldBackgroundColor: ShopColors.background,
  colorScheme: ColorScheme.fromSeed(seedColor: ShopColors.purple),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 14, color: ShopColors.ink),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(color: Color(0xFFB5B5BC), fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: ShopColors.purple),
    ),
  ),
);
