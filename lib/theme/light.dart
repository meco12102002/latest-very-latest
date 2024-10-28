import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFFED50A), // Button color
  scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Light gray background for the scaffold
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFFFFFF), // White surface for cards and dialogs
    primary: Color(0xFFFED50A), // Primary color for buttons and highlights
    secondary: Color(0xFF4B5563), // Dark gray for secondary elements
    onPrimary: Colors.black, // Text color on primary surfaces
    onSecondary: Colors.white, // Text color on secondary surfaces
    background: Color(0xFFF3F4F6), // Background color
    onBackground: Colors.black, // Text color on background
    error: Color(0xFFE53E3E), // Error color
    onError: Colors.white, // Text color on error
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFED50A), // AppBar background
    iconTheme: IconThemeData(color: Colors.black), // AppBar icons
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    elevation: 2, // Slight elevation for shadow effect
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFFED50A), // Button color
    textTheme: ButtonTextTheme.primary, // Text color on button
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Colors.black87,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      color: Colors.black54,
      fontSize: 12,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.grey.shade700, // General icon color
  ),
  cardTheme: CardTheme(
    color: Colors.white, // Card background color
    elevation: 4, // Slight elevation for card shadow
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16), // Rounded corners for cards
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade200, // Light fill color for text fields
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16), // Rounded corners
      borderSide: BorderSide.none, // Remove border
    ),
    labelStyle: const TextStyle(color: Colors.black), // Label color
    hintStyle: TextStyle(color: Colors.grey.shade600), // Hint text color
  ),
);
