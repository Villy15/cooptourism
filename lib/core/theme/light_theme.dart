import 'package:flutter/material.dart';

// COLOR VARIABLES
const Color primaryColor = Color(0xFF667080);
const Color secondaryColor = Color(0xFFEEF1F4);

// FONT SIZE VARIABLES
const double large = 48;
const double medium = 20;
const double small = 14;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: false,
  
  // Color Theme
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: primaryColor,
    secondary: secondaryColor
  ),

  // App Bar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: medium,
      fontWeight: FontWeight.bold,
      color: primaryColor
    ),
    iconTheme: IconThemeData(
      color: secondaryColor
    ),
  ),

  // Font Family
  fontFamily: 'Inter',

  // Text Themes
  textTheme: const TextTheme(
  
    // Large
    bodyLarge: TextStyle(
      fontSize: large,
      fontWeight: FontWeight.bold,
      color: primaryColor
    ),

    // Medium
    bodyMedium: TextStyle(
      fontSize: medium,
      fontWeight: FontWeight.w400,
      color: primaryColor
    ),

    // Use for what would go under the title
    bodySmall: TextStyle(
      fontSize: small,
      fontWeight: FontWeight.w400,
      color: primaryColor
    ),

    headlineLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: primaryColor
    ),

    headlineMedium: TextStyle(
      fontSize: medium,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
    
    // Use for title like stuff
    headlineSmall: TextStyle(
      fontSize: small,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
  ),
);