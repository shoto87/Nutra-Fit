import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners of changes
  }

  ThemeData get themeData {
    return _isDarkMode
        ? ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark().copyWith(
              primary: Color(0xFF5a9942), // Dimmed green
              background: Color(0xFF2a2d2a), // Dark background
            ),
            scaffoldBackgroundColor: Color(0xFF2a2d2a), // Scaffold background
            appBarTheme: AppBarTheme(
              color: Color(0xFF5a9942), // Dimmed app bar
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Color(0xFF5a9942), // Dimmed button
            ),
            textTheme: TextTheme(
              bodyLarge:
                  TextStyle(color: Colors.white), // Light text in dark mode
              bodyMedium: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(
              color: Color(0xFF5a9942), // Dimmed icon color
            ),
          )
        : ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Color(0xFF7ed957), // Vibrant green
              background: Color(0xFFccffb6), // Light background
            ),
            scaffoldBackgroundColor: Color(0xFFccffb6), // Scaffold background
            appBarTheme: AppBarTheme(
              color: Color(0xFF7ed957), // Vibrant green app bar
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Color(0xFF7ed957), // Vibrant button
            ),
            textTheme: TextTheme(
              bodyLarge:
                  TextStyle(color: Colors.black), // Dark text in light mode
              bodyMedium: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(
              color: Color(0xFF7ed957), // Vibrant icon color
            ),
          );
  }
}
