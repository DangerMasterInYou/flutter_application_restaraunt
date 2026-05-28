import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF7F7F7),
  primaryColor: const Color(0xFF1A1A1A),
  dividerColor: Colors.black12,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
    elevation: 0,
    backgroundColor: Color(0xFFF7F7F7),
    titleTextStyle: TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  ),
  listTileTheme: const ListTileThemeData(iconColor: Color(0xFF1A1A1A)),
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyMedium: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        labelSmall: TextStyle(
          color: const Color(0xFF1A1A1A).withOpacity(0.7),
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        headlineMedium: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.w500,
          fontSize: 24,
        ),
        titleMedium: const TextStyle(
          fontSize: 28,
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.w700,
        ),
        labelMedium: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.w500,
        ),
        titleSmall: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.w500,
        ),
        titleLarge: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.bold,
        ),
      ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: const Color(0xFF1A1A1A).withOpacity(0.7)),
    hintStyle: TextStyle(color: const Color(0xFF1A1A1A).withOpacity(0.5)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: const Color(0xFF1A1A1A).withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
    ),
    prefixIconColor: const Color(0xFF1A1A1A).withOpacity(0.7),
    suffixIconColor: const Color(0xFF1A1A1A).withOpacity(0.7),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF7F7F7),
      foregroundColor: const Color(0xFF1A1A1A),
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
      foregroundColor: const Color(0xFF1A1A1A),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
  cardTheme: CardThemeData(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
    ),
    clipBehavior: Clip.antiAlias,
    color: const Color(0xFFFFFFFF),
  ),
);

final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    primarySwatch: Colors.grey,
    primaryColor: const Color(0xFFE0E0E0),
    dividerColor: Colors.white24,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Color(0xFFE0E0E0)),
      elevation: 0,
      backgroundColor: Color(0xFF1A1A1A),
      titleTextStyle: TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    listTileTheme: const ListTileThemeData(iconColor: Color(0xFFE0E0E0)),
    textTheme: TextTheme(
      bodyMedium: const TextStyle(
        color: Color(0xFFE0E0E0),
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      labelSmall: TextStyle(
        color: const Color(0xFFE0E0E0).withOpacity(0.7),
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      headlineMedium: const TextStyle(
        color: Color(0xFFE0E0E0),
        fontWeight: FontWeight.w500,
        fontSize: 24,
      ),
      titleMedium: const TextStyle(
        fontSize: 26,
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w700,
      ),
      labelMedium: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w500,
      ),
      titleSmall: const TextStyle(
        color: Color(0xFFE0E0E0),
        fontWeight: FontWeight.w500,
      ),
      titleLarge: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: const Color(0xFFE0E0E0).withOpacity(0.7)),
      hintStyle: TextStyle(color: const Color(0xFFE0E0E0).withOpacity(0.5)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFFE0E0E0).withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      prefixIconColor: const Color(0xFFE0E0E0).withOpacity(0.7),
      suffixIconColor: const Color(0xFFE0E0E0).withOpacity(0.7),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2D2D2D),
        foregroundColor: const Color(0xFFFFFFFF),
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
        foregroundColor: const Color(0xFFE0E0E0),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFE0E0E0)),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF222222),
    ));
