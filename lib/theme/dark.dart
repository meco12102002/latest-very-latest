import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFFED50A), // Bright yellow for primary elements
  scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Darker background for the scaffold
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF1B1B1B), // Dark gray for surface elements like cards
    primary: Color(0xFFFED50A), // Bright yellow for buttons and highlights
    secondary: Color(0xFFBB86FC), // Soft purple for secondary elements
    onPrimary: Colors.black, // Text color on primary surfaces
    onSecondary: Colors.white, // Background color
    onSurface: Colors.white, // Text color on background
    error: Color(0xFFCF6679), // Error color
    onError: Colors.white, // Text color on error
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1B1B1B), // Dark background for AppBar
    iconTheme: IconThemeData(color: Colors.white), // White icons in AppBar
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    elevation: 4, // Slight elevation for shadow effect
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFFED50A), // Button color
    textTheme: ButtonTextTheme.primary, // Text color on button
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Colors.grey, // Lighter gray for body text
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      color: Colors.grey, // Lighter gray for small text
      fontSize: 12,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.grey.shade300, // Light gray for icons
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF1B1B1B), // Dark background color for cards
    elevation: 6, // More elevation for card shadow
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners for cards
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C), // Dark fill color for text fields
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners
      borderSide: BorderSide.none, // Remove border
    ),
    labelStyle: const TextStyle(color: Colors.white), // Label color
    hintStyle: TextStyle(color: Colors.grey.shade400), // Hint text color
  ),
);
