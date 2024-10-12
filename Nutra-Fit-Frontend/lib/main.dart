import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme/theme_provider.dart';
import './auth/login_page.dart';
import './pages/dashboard.dart';
import './pages/diet_menu_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Nutra Fit Diet Planner',
      theme: themeProvider.themeData, // Global theme application
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/diet-menu': (context) => DietMenuScreen(),
      },
    );
  }
}
