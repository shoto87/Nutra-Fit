import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme/theme_provider.dart'; // Import your ThemeProvider
import 'package:login_flask/pages/diet_menu_screen.dart';
import './auth/login_page.dart';
import './pages/dashboard.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'My App',
          theme: themeProvider.themeData, // Use the theme from ThemeProvider
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginPage(),
            '/dashboard': (context) => DashboardPage(),
            '/diet-menu': (context) => DietMenuScreen(),
          },
        );
      },
    );
  }
}
