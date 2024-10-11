import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners to rebuild with the new theme
  }

  ThemeData get themeData {
    return _isDarkMode
        ? ThemeData.dark()
        : ThemeData.light().copyWith(
            primaryColor: Color(0xFF7ed957),
            scaffoldBackgroundColor: Color(0xFFccffb6),
            appBarTheme: AppBarTheme(
              color: Color(0xFF7ed957),
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Color(0xFF7ed957),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(
              color: Color(0xFF7ed957),
            ),
          );
  }
}
