import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 31, 31, 31),
  primarySwatch: Colors.yellow,
  primaryColor: Colors.green,
  dividerColor: Colors.white24,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 0,
    backgroundColor: Color.fromARGB(255, 31, 31, 31),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  ),
  listTileTheme: const ListTileThemeData(iconColor: Colors.white),
  textTheme: TextTheme(
    bodyMedium: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 20,
    ),
    labelSmall: TextStyle(
      color: Colors.white.withOpacity(0.6),
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    headlineMedium: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 24,
    ),
    titleMedium: const TextStyle(
      fontSize: 28,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    ),
    labelMedium: const TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.green, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    prefixIconColor: Colors.white.withOpacity(0.7),
    suffixIconColor: Colors.white.withOpacity(0.7),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
);
